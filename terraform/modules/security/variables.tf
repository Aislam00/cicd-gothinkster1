variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

# Remove the alb_security_group_ids variable - it's causing circular dependency

variable "common_tags" {
  type    = map(string)
  default = {}
}
