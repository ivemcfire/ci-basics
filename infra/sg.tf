# Two security groups, chained. This is the pattern every ALB+ECS stack uses.
resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  description = "ALB: 80 from home only"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group" "task" {
  name        = "${var.name}-task-sg"
  description = "task: 8080 from the ALB only"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = var.home_cidr
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "task_from_alb" {
  security_group_id = aws_security_group.task.id
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"

  # FILL 1: the task accepts 8080 from the ALB's security group, not from a CIDR.
  # the argument name is referenced_security_group_id
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "task_all" {
  security_group_id = aws_security_group.task.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
