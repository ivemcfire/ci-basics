terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# local state on purpose today: the S3 backend is its own bootstrap stack (W3D5),
# and we are not practicing that here.
provider "aws" {
  region = var.region
  # no profile = here: credentials come from the environment, never the code
}
