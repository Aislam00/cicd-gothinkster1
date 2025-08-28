variable "domain_name" {
  type = string
}

variable "app_subdomain" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
