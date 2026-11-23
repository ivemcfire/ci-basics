variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "name" {
  type    = string
  default = "ivx-web"
}

variable "home_cidr" {
  description = "your public IP /32 - the only thing allowed to reach the ALB"
  type        = string
}

variable "image_digest" {
  description = "pin the image by content, not by tag"
  type        = string
}
