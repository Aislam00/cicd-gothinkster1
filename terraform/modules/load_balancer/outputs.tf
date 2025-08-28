output "load_balancer_id" {
  value = aws_lb.main.id
}

output "load_balancer_arn" {
  value = aws_lb.main.arn
}

output "load_balancer_dns_name" {
  value = aws_lb.main.dns_name
}

output "load_balancer_zone_id" {
  value = aws_lb.main.zone_id
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}

output "target_group_name" {
  value = aws_lb_target_group.app.name
}
