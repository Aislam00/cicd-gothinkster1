variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "realworld"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Resource owner"
  type        = string
  default     = "DevOps"
}


variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "Number of subnets"
  type        = number
  default     = 2

  validation {
    condition     = var.subnet_count >= 2 && var.subnet_count <= 6
    error_message = "Subnet count must be between 2 and 6."
  }
}

variable "jenkins_instance_type" {
  description = "Instance type for Jenkins"
  type        = string
  default     = "t3.medium"

  validation {
    condition = contains([
      "t3.small", "t3.medium", "t3.large",
      "m5.large", "m5.xlarge"
    ], var.jenkins_instance_type)
    error_message = "Jenkins instance type must be a valid EC2 instance type."
  }
}

variable "app_instance_type" {
  description = "Instance type for application servers"
  type        = string
  default     = "t3.small"
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "app_min_size" {
  description = "Minimum app instances"
  type        = number
  default     = 1

  validation {
    condition     = var.app_min_size >= 1
    error_message = "Minimum size must be at least 1."
  }
}

variable "app_max_size" {
  description = "Maximum app instances"
  type        = number
  default     = 3

  validation {
    condition     = var.app_max_size >= var.app_min_size
    error_message = "Maximum size must be greater than or equal to minimum size."
  }
}

variable "app_desired_capacity" {
  description = "Desired app instances"
  type        = number
  default     = 2
}

variable "public_key" {
  description = "SSH public key"
  type        = string

  validation {
    condition     = can(regex("^ssh-(rsa|ed25519|ecdsa)", var.public_key))
    error_message = "Public key must be a valid SSH public key."
  }
}

variable "jenkins_admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.jenkins_admin_password) >= 8
    error_message = "Jenkins admin password must be at least 8 characters long."
  }
}

variable "domain_name" {
  description = "Root domain name"  
  type        = string
  default     = "iasolutions.co.uk"
}
