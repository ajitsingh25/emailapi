[
  {
    "name": "emailapi",
    "image": "${docker_image_url}",
    "essential": true,
    "memory": 512,
    "links": [],
    "portMappings": [
      {
        "containerPort": 8000,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "command": ["python", "-Wd", "manage.py", "runserver", "0.0.0.0:8000"],
    "environment": [
      {
        "name": "ALLOWED_HOSTS",
        "value": "${allowed_hosts}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/emailapi",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "emailapi-log-stream"
      }
    }
  }
]