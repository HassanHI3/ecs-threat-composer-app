terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "ecs-threat-composer-bucket"
    key          = "terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}

provider "aws" {
  region = "eu-west-2"
}