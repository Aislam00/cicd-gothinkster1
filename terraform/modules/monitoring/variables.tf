variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "alb_full_name" {
  type = string
}

variable "asg_name" {
  type = string
}

variable "log_retention_days" {
  type    = number
  default = 14
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
