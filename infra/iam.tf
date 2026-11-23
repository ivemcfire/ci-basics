data "aws_iam_policy_document" "ecs_tasks_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "exec" {
  name               = "${var.name}-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume.json
}

resource "aws_iam_role_policy_attachment" "exec" {
  role       = aws_iam_role.exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "exec_ssm" {
  statement {
    actions   = ["ssm:GetParameters"]
    resources = [local.app_message_arn]
  }
}

resource "aws_iam_role_policy" "exec_ssm" {
  name   = "${var.name}-exec-ssm"
  role   = aws_iam_role.exec.id
  policy = data.aws_iam_policy_document.exec_ssm.json
}
