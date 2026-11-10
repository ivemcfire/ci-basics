resource "aws_ecr_repository" "web" {
  name                 = var.name
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true # lab only: lets destroy remove a repo that still holds images
}
