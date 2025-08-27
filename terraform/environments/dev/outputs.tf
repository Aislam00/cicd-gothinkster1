output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "jenkins_instance_id" {
  description = "Jenkins instance ID"
  value       = module.ec2.jenkins_instance_id
}

output "jenkins_public_ip" {
  description = "Jenkins public IP"
  value       = module.ec2.jenkins_public_ip
}

output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${module.ec2.jenkins_public_ip}:8080"
}

output "app_url" {
  description = "Application URL"
  value       = "http://${module.load_balancer.load_balancer_dns_name}"
}

output "load_balancer_dns_name" {
  description = "Load balancer DNS name"
  value       = module.load_balancer.load_balancer_dns_name
}

output "ssh_command" {
  description = "SSH command for Jenkins"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${module.ec2.jenkins_public_ip}"
}

output "app_domain" {
  description = "Application domain"
  value       = module.dns.app_domain
}

output "certificate_arn" {
  description = "SSL certificate ARN"
  value       = module.dns.certificate_arn
}

output "dashboard_url" {
  description = "CloudWatch dashboard URL"
  value       = module.monitoring.dashboard_url
}

output "database_endpoint" {
  description = "Database endpoint"
  value       = module.rds.db_endpoint
}

output "database_secrets" {
  description = "Database secrets ARNs"
  value = {
    db_secret  = module.secrets.db_secret_arn
    jwt_secret = module.secrets.jwt_secret_arn
  }
}

output "frontend_url" {
  description = "Frontend CloudFront URL"
  value       = "https://${module.frontend.cloudfront_domain}"
}
