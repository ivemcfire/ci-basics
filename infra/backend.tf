terraform {
  backend "s3" {
    bucket       = "ivx-tfstate-817210751918"
    key          = "ci-basics/infra/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}
