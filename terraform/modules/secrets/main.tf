resource "random_password" "db_password" {
  length  = 32
  special = true
  # Exclude characters that RDS doesn't allow: /, @, ", space
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
  name        = "/realworld/${var.environment}/database"
  description = "Database credentials for ${var.project_name}-${var.environment}"
  
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
  name        = "/realworld/${var.environment}/jwt"
  description = "JWT secret for ${var.project_name}-${var.environment}"
  
  tags = var.common_tags
}

resource "aws_secretsmanager_secret_version" "jwt" {
  secret_id = aws_secretsmanager_secret.jwt.id
  secret_string = jsonencode({
    secret = random_password.jwt_secret.result
  })
}


resource "aws_iam_policy" "secrets_read" {
  name        = "${var.project_name}-${var.environment}-secrets-read"
  description = "Policy to read secrets for ${var.project_name}"

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
