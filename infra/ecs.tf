resource "aws_ecs_cluster" "main" {
  name = "${var.name}-cluster"
}

resource "aws_cloudwatch_log_group" "web" {
  name              = "/ecs/${var.name}"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "web" {
  family                   = var.name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.exec.arn

  container_definitions = jsonencode([{
    name         = "web"
    image        = "${aws_ecr_repository.web.repository_url}@${var.image_digest}"
    essential    = true
    portMappings = [{ containerPort = 8080, protocol = "tcp" }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.web.name
        "awslogs-region"        = var.region
        "awslogs-stream-prefix" = "web"
      }
    }
  }])
}

resource "aws_ecs_service" "web" {
  name            = "${var.name}-svc"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.task.id]
    assign_public_ip = true # the no-NAT path
  }

  load_balancer {
    # FILL 3: wire the service into the ALB. three values, all of them
    # already defined elsewhere in this config or in the task definition.
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "web"
    container_port   = 8080
  }

  # the listener must exist before the service may register targets
  depends_on = [aws_lb_listener.http]
}
