variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = "eu-west-2a"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu"
  type        = string
  default     = "ami-0c76bd4bd302b30ec"
}

variable "key_name" {
  description = "AWS key pair name"
  type        = string
  default     = "jenkins-key"
}

variable "public_key_path" {
  description = "Path to public key file"
  type        = string
  default     = "jenkins_key.pub"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "jenkins-cicd"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Resource owner"
  type        = string
  default     = "AlaminIslam"
}