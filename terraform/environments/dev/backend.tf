terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket  = "iasolutions-terraform-state-475641479654"
    key     = "realworld/dev/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}
