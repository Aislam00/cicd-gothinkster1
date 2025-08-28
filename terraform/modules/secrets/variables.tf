variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "db_secret_name" {
  type = string
}

variable "jwt_secret_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_port" {
  type    = string
  default = "5432"
}

variable "db_name" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
