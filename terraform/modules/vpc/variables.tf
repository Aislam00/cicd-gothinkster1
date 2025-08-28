variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_count" {
  type    = number
  default = 2
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
