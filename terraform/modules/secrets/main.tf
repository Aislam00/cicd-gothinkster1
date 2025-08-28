resource "random_password" "db_password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "jwt_secret" {
  length  = 64
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "aws_secretsmanager_secret" "database" {
  name                    = "/realworld/${var.environment}/database"
  recovery_window_in_days = 0

  tags = var.common_tags
}

resource "aws_secretsmanager_secret_version" "database" {
  secret_id = aws_secretsmanager_secret.database.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
  })
}

resource "aws_secretsmanager_secret" "jwt" {
  name                    = "/realworld/${var.environment}/jwt"
  recovery_window_in_days = 0

  tags = var.common_tags
}

resource "aws_secretsmanager_secret_version" "jwt" {
  secret_id = aws_secretsmanager_secret.jwt.id
  secret_string = jsonencode({
    secret = random_password.jwt_secret.result
  })
}

resource "aws_iam_policy" "secrets_read" {
  name = "${var.project_name}-${var.environment}-secrets-read"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          aws_secretsmanager_secret.database.arn,
          aws_secretsmanager_secret.jwt.arn
        ]
      }
    ]
  })

  tags = var.common_tags
}
