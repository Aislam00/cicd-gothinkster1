output "vpc_id" {
  value = module.vpc.vpc_id
}

output "jenkins_instance_id" {
  value = module.ec2.jenkins_instance_id
}

output "jenkins_public_ip" {
  value = module.ec2.jenkins_public_ip
}

output "jenkins_url" {
  value = "http://${module.ec2.jenkins_public_ip}:8080"
}

output "app_url" {
  value = "http://${module.load_balancer.load_balancer_dns_name}"
}

output "load_balancer_dns_name" {
  value = module.load_balancer.load_balancer_dns_name
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/id_rsa ubuntu@${module.ec2.jenkins_public_ip}"
}

output "dashboard_url" {
  value = module.monitoring.dashboard_url
}

output "database_endpoint" {
  value = module.rds.db_endpoint
}

output "database_secrets" {
  value = {
    db_secret  = module.secrets.db_secret_arn
    jwt_secret = module.secrets.jwt_secret_arn
  }
}

output "frontend_url" {
  value = "https://${module.frontend.cloudfront_domain}"
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}
