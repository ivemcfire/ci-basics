output "alb_url" {
  value = "http://${aws_lb.web.dns_name}"
}

output "ecr_repo" {
  value = aws_ecr_repository.web.repository_url
}
