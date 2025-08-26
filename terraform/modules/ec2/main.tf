data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = var.public_key

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-keypair"
  })
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.jenkins_instance_type
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.jenkins_security_group_id]
  key_name               = aws_key_pair.main.key_name
  iam_instance_profile   = var.jenkins_instance_profile_name

  user_data = base64encode(templatefile("${path.module}/templates/jenkins-userdata.sh", {
    jenkins_admin_password = var.jenkins_admin_password
    project_name          = var.project_name
    environment           = var.environment
  }))

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true

    tags = merge(var.common_tags, {
      Name = "${var.project_name}-${var.environment}-jenkins-root"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-jenkins"
    Type = "jenkins"
  })
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-${var.environment}-app-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.app_instance_type
  key_name      = aws_key_pair.main.key_name

  vpc_security_group_ids = [var.app_security_group_id]

  iam_instance_profile {
    name = var.app_instance_profile_name
  }

  user_data = base64encode(templatefile("${path.module}/templates/app-userdata.sh", {
    project_name = var.project_name
    environment  = var.environment
  }))

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
      volume_type = "gp3"
      encrypted   = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.project_name}-${var.environment}-app"
      Type = "application"
    })
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.common_tags
}

resource "aws_autoscaling_group" "app" {
  name                = "${var.project_name}-${var.environment}-app-asg"
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = var.target_group_arns
  health_check_type   = "ELB"
  health_check_grace_period = 300

  min_size         = var.app_min_size
  max_size         = var.app_max_size
  desired_capacity = var.app_desired_capacity

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-app-asg"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
