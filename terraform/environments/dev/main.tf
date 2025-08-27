provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      Owner       = var.owner
      ManagedBy   = "terraform"
      Domain      = var.domain_name
    }
  }
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
    Domain      = var.domain_name
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
  certificate_arn    = module.dns.certificate_arn
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

module "dns" {
  source = "../../modules/dns"
  
  domain_name    = var.domain_name
  app_subdomain  = "dev-api.${var.domain_name}"
  alb_dns_name   = module.load_balancer.load_balancer_dns_name
  alb_zone_id    = module.load_balancer.load_balancer_zone_id
  common_tags    = local.common_tags
}

module "monitoring" {
  source = "../../modules/monitoring"
  
  project_name     = var.project_name
  environment      = var.environment
  aws_region       = var.aws_region
  alb_full_name    = module.load_balancer.load_balancer_arn
  asg_name         = module.ec2.autoscaling_group_name
  log_retention_days = 14
  common_tags      = local.common_tags
}

module "secrets" {
  source = "../../modules/secrets"
  
  project_name   = var.project_name
  environment    = var.environment
  db_secret_name = "/${var.project_name}/${var.environment}/database"
  jwt_secret_name = "/${var.project_name}/${var.environment}/jwt"
  db_username    = "realworld"
  db_host        = module.rds.db_endpoint
  db_port        = "5432"
  db_name        = "realworld"
  common_tags    = local.common_tags
}

module "rds" {
  source = "../../modules/rds"
  
  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  app_security_group_id   = module.security.app_security_group_id
  db_instance_class       = "db.t3.micro"
  allocated_storage       = 20
  max_allocated_storage   = 100
  db_name                 = "realworld"
  db_username             = "realworld"
  db_password             = module.secrets.db_password
  backup_retention_period = 7
  multi_az               = false
  skip_final_snapshot    = true
  common_tags            = local.common_tags
}
