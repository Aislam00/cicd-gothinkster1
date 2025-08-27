resource "random_password" "db_password" {
  length  = 32
  special = true
}

resource "random_password" "jwt_secret" {
  length  = 64
  special = false
}

resource "aws_secretsmanager_secret" "database" {
  name                    = var.db_secret_name
  description             = "Database credentials"
  recovery_window_in_days = 7
  
  tags = var.common_tags
}

resource "aws_secretsmanager_secret_version" "database" {
  secret_id = aws_secretsmanager_secret.database.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
    host     = var.db_host
    port     = var.db_port
    dbname   = var.db_name
    url      = "postgresql://${var.db_username}:${random_password.db_password.result}@${var.db_host}:${var.db_port}/${var.db_name}"
  })
}

resource "aws_secretsmanager_secret" "jwt" {
  name                    = var.jwt_secret_name
  description             = "JWT secret key"
  recovery_window_in_days = 7
  
  tags = var.common_tags
}

resource "aws_secretsmanager_secret_version" "jwt" {
  secret_id = aws_secretsmanager_secret.jwt.id
  secret_string = jsonencode({
    secret = random_password.jwt_secret.result
  })
}

data "aws_iam_policy_document" "secrets_read" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [
      aws_secretsmanager_secret.database.arn,
      aws_secretsmanager_secret.jwt.arn
    ]
  }
}

resource "aws_iam_policy" "secrets_read" {
  name        = "${var.project_name}-${var.environment}-secrets-read"
  description = "Read secrets policy"
  policy      = data.aws_iam_policy_document.secrets_read.json
  
  tags = var.common_tags
}
