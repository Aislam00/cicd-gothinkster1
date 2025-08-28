variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "jenkins_security_group_id" {
  type = string
}

variable "app_security_group_id" {
  type = string
}

variable "jenkins_instance_profile_name" {
  type = string
}

variable "app_instance_profile_name" {
  type = string
}

variable "target_group_arns" {
  type    = list(string)
  default = []
}

variable "public_key" {
  type = string
}

variable "jenkins_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "app_instance_type" {
  type    = string
  default = "t3.small"
}

variable "app_min_size" {
  type    = number
  default = 1
}

variable "app_max_size" {
  type    = number
  default = 3
}

variable "app_desired_capacity" {
  type    = number
  default = 2
}

variable "jenkins_admin_password" {
  type      = string
  sensitive = true
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "db_endpoint" {
  type = string
}

variable "ecr_registry" {
  type = string
}
