resource "aws_cloudwatch_log_group" "emailapi-log-group" {
  name              = "/ecs/emailapi"
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_stream" "emailapi-log-stream" {
  name           = "emailapi-log-stream"
  log_group_name = aws_cloudwatch_log_group.emailapi-log-group.name
}