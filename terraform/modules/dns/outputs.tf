output "certificate_arn" {
  value = aws_acm_certificate_validation.app.certificate_arn
}

output "app_domain" {
  value = aws_route53_record.app.fqdn
}

output "zone_id" {
  value = data.aws_route53_zone.main.zone_id
}
