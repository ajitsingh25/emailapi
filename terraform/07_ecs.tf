resource "aws_ecs_cluster" "my-ecs" {
  name = "${var.ecs_cluster_name}-cluster"
}

resource "aws_launch_configuration" "ecs" {
  name                        = "${var.ecs_cluster_name}-cluster"
  image_id                    = lookup(var.amis, var.region)
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.ecs.id]
  iam_instance_profile        = aws_iam_instance_profile.ecs.name
  key_name                    = aws_key_pair.my-key.key_name
  associate_public_ip_address = true
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER='${var.ecs_cluster_name}-cluster' > /etc/ecs/ecs.config"
}

data "template_file" "app" {
  template = file("templates/emailapi.json.tpl")

  vars = {
    docker_image_url        = var.docker_image_url
    region                  = var.region
    allowed_hosts           = var.allowed_hosts
  }
}

resource "aws_ecs_task_definition" "app" {
  family                = "emailapi"
  container_definitions = data.template_file.app.rendered

}

resource "aws_ecs_service" "my-service" {
  name            = "${var.ecs_cluster_name}-service"
  cluster         = aws_ecs_cluster.my-ecs.id
  task_definition = aws_ecs_task_definition.app.arn
  iam_role        = aws_iam_role.ecs-service-role.arn
  desired_count   = var.app_count
  depends_on      = [aws_alb_listener.ecs-alb-http-listener, aws_iam_role_policy.ecs-service-role-policy]

  load_balancer {
    target_group_arn = aws_alb_target_group.default-target-group.arn
    container_name   = "emailapi"
    container_port   = 8000
  }
}