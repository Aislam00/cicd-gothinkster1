resource "aws_kms_key" "logs" {
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs"
        Effect = "Allow"
        Principal = {
          Service = "logs.eu-west-2.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_kms_alias" "logs" {
  name          = "alias/${var.project_name}-${var.environment}-logs"
  target_key_id = aws_kms_key.logs.key_id
}

data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ec2/${var.project_name}-${var.environment}-app"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.logs.arn

  tags = var.common_tags
}

resource "aws_cloudwatch_log_group" "jenkins" {
  name              = "/aws/ec2/${var.project_name}-${var.environment}-jenkins"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.logs.arn

  tags = var.common_tags
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_full_name],
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_full_name],
            ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "LoadBalancer", var.alb_full_name],
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", var.alb_full_name]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "Application Load Balancer Metrics"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.asg_name],
            ["AWS/EC2", "NetworkIn", "AutoScalingGroupName", var.asg_name],
            ["AWS/EC2", "NetworkOut", "AutoScalingGroupName", var.asg_name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "EC2 Instance Metrics"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  tags = var.common_tags
}

resource "aws_cloudwatch_metric_alarm" "target_5xx_errors" {
  alarm_name          = "${var.project_name}-${var.environment}-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"

  dimensions = {
    LoadBalancer = var.alb_full_name
  }

  tags = var.common_tags
}
