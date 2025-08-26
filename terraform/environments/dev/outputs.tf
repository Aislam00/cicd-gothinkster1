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
