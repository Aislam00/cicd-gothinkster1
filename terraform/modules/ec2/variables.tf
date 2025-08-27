variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "jenkins_security_group_id" {
  description = "Security group ID for Jenkins"
  type        = string
}

variable "app_security_group_id" {
  description = "Security group ID for application"
  type        = string
}

variable "jenkins_instance_profile_name" {
  description = "IAM instance profile name for Jenkins"
  type        = string
}

variable "app_instance_profile_name" {
  description = "IAM instance profile name for application"
  type        = string
}

variable "target_group_arns" {
  description = "List of target group ARNs for the auto scaling group"
  type        = list(string)
  default     = []
}

variable "public_key" {
  description = "SSH public key"
  type        = string
}

variable "jenkins_instance_type" {
  description = "Instance type for Jenkins"
  type        = string
  default     = "t3.medium"
}

variable "app_instance_type" {
  description = "Instance type for application servers"
  type        = string
  default     = "t3.small"
}

variable "app_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "app_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

variable "app_desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}

variable "jenkins_admin_password" {
  description = "Admin password for Jenkins"
  type        = string
  sensitive   = true
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "db_endpoint" {
  description = "Database endpoint"
  type        = string
}

variable "ecr_registry" {
  description = "ECR registry URL"
  type        = string
}
