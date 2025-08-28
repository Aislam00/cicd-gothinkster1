output "jenkins_instance_id" {
  value = aws_instance.jenkins.id
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "jenkins_private_ip" {
  value = aws_instance.jenkins.private_ip
}

output "key_pair_name" {
  value = aws_key_pair.main.key_name
}

output "launch_template_id" {
  value = aws_launch_template.app.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.app.name
}
