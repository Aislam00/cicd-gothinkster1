variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "certificate_arn" {
  type    = string
  default = ""
}

variable "target_port" {
  type    = number
  default = 3000
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "health_check_healthy_threshold" {
  type    = number
  default = 2
}

variable "health_check_unhealthy_threshold" {
  type    = number
  default = 2
}

variable "health_check_timeout" {
  type    = number
  default = 5
}

variable "health_check_interval" {
  type    = number
  default = 30
}

variable "health_check_matcher" {
  type    = string
  default = "200"
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "common_tags" {
  type    = map(string)
  default = {}
}