terraform {
  backend "s3" {
    bucket         = "iasolutions-terraform-state-475641479654"
    key            = "realworld/dev/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}
