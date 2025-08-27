output "dashboard_url" {
  description = "CloudWatch dashboard URL"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${var.project_name}-${var.environment}"
}

output "app_log_group" {
  description = "Application log group name"
  value       = aws_cloudwatch_log_group.app.name
}

output "jenkins_log_group" {
  description = "Jenkins log group name"
  value       = aws_cloudwatch_log_group.jenkins.name
}
