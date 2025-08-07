output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.jenkins_vpc.id
}

output "subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.jenkins_sg.id
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.jenkins.id
}

output "instance_public_ip" {
  description = "EC2 instance public IP"
  value       = aws_instance.jenkins.public_ip
}

output "instance_private_ip" {
  description = "EC2 instance private IP"
  value       = aws_instance.jenkins.private_ip
}

output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "ssh_connection" {
  description = "SSH connection command"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.jenkins.public_ip}"
}