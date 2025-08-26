provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      Owner       = var.owner
      ManagedBy   = "terraform"
    }
  }
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  subnet_count = var.subnet_count
  common_tags  = local.common_tags
}

module "iam" {
  source = "../../modules/iam"
  
  project_name = var.project_name
  environment  = var.environment
  common_tags  = local.common_tags
}

module "security" {
  source = "../../modules/security"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  common_tags  = local.common_tags
}

module "load_balancer" {
  source = "../../modules/load_balancer"
  
  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [module.security.alb_security_group_id]
  common_tags        = local.common_tags
}

module "ec2" {
  source = "../../modules/ec2"
  
  project_name                  = var.project_name
  environment                   = var.environment
  public_subnet_ids             = module.vpc.public_subnet_ids
  private_subnet_ids            = module.vpc.private_subnet_ids
  jenkins_security_group_id     = module.security.jenkins_security_group_id
  app_security_group_id         = module.security.app_security_group_id
  jenkins_instance_profile_name = module.iam.jenkins_instance_profile_name
  app_instance_profile_name     = module.iam.app_instance_profile_name
  target_group_arns             = [module.load_balancer.target_group_arn]
  public_key                    = var.public_key
  jenkins_instance_type         = var.jenkins_instance_type
  app_instance_type             = var.app_instance_type
  app_min_size                  = var.app_min_size
  app_max_size                  = var.app_max_size
  app_desired_capacity          = var.app_desired_capacity
  jenkins_admin_password        = var.jenkins_admin_password
  common_tags                   = local.common_tags
}
