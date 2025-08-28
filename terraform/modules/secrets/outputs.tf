output "db_secret_arn" {
  value = aws_secretsmanager_secret.database.arn
}

output "jwt_secret_arn" {
  value = aws_secretsmanager_secret.jwt.arn
}

output "secrets_policy_arn" {
  value = aws_iam_policy.secrets_read.arn
}

output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}
