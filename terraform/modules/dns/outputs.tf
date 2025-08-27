output "certificate_arn" {
  description = "SSL certificate ARN"
  value       = aws_acm_certificate_validation.app.certificate_arn
}

output "app_domain" {
  description = "Application domain"
  value       = aws_route53_record.app.fqdn
}

output "zone_id" {
  description = "Route53 zone ID"
  value       = data.aws_route53_zone.main.zone_id
}
