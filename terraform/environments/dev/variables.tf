variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "project_name" {
  type    = string
  default = "realworld"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "owner" {
  type    = string
  default = "DevOps"
}


variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_count" {
  type    = number
  default = 2

  validation {
    condition     = var.subnet_count >= 2 && var.subnet_count <= 6
    error_message = "Subnet count must be between 2 and 6."
  }
}

variable "jenkins_instance_type" {
  type    = string
  default = "t3.medium"

  validation {
    condition = contains([
      "t3.small", "t3.medium", "t3.large",
      "m5.large", "m5.xlarge"
    ], var.jenkins_instance_type)
    error_message = "Jenkins instance type must be a valid EC2 instance type."
  }
}

variable "app_instance_type" {
  type    = string
  default = "t3.small"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "app_min_size" {
  type    = number
  default = 1

  validation {
    condition     = var.app_min_size >= 1
    error_message = "Minimum size must be at least 1."
  }
}

variable "app_max_size" {
  type    = number
  default = 3

  validation {
    condition     = var.app_max_size >= var.app_min_size
    error_message = "Maximum size must be greater than or equal to minimum size."
  }
}

variable "app_desired_capacity" {
  type    = number
  default = 2
}

variable "public_key" {
  type = string

  validation {
    condition     = can(regex("^ssh-(rsa|ed25519|ecdsa)", var.public_key))
    error_message = "Public key must be a valid SSH public key."
  }
}

variable "jenkins_admin_password" {
  type      = string
  sensitive = true

  validation {
    condition     = length(var.jenkins_admin_password) >= 8
    error_message = "Jenkins admin password must be at least 8 characters long."
  }
}

variable "domain_name" {
  type    = string
  default = "iasolutions.co.uk"
}
