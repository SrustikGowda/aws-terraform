# Security Group for Web Server
resource "aws_security_group" "web" {
  name_prefix = "${var.project_name}-web-sg-"
  description = "Security group for web server - allows HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

  # SSH access from specified IP (only if not 0.0.0.0/0)
  dynamic "ingress" {
    for_each = var.allowed_ssh_cidr != "0.0.0.0/0" ? [1] : []
    content {
      description = "SSH from allowed IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.allowed_ssh_cidr]
    }
  }

  # HTTP access - configurable via variable
  dynamic "ingress" {
    for_each = var.allow_http_public ? [1] : []
    content {
      description = "HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # HTTPS access - configurable via variable
  dynamic "ingress" {
    for_each = var.allow_https_public ? [1] : []
    content {
      description = "HTTPS from anywhere"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Restricted outbound traffic (only necessary ports)
  # HTTPS for package updates and API calls
  egress {
    description = "HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP for package updates (if needed)
  egress {
    description = "HTTP outbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # DNS for name resolution
  egress {
    description = "DNS TCP outbound"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "DNS UDP outbound"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # NTP for time synchronization
  egress {
    description = "NTP outbound"
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

# IAM Role for EC2 Instance (optional - only if IAM permissions are available)
resource "aws_iam_role" "ec2_role" {
  count = var.enable_iam_role ? 1 : 0
  name  = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ec2-role"
  }
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.enable_iam_role ? 1 : 0
  name  = "${var.project_name}-ec2-profile"
  role  = aws_iam_role.ec2_role[0].name

  tags = {
    Name = "${var.project_name}-ec2-profile"
  }
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami           = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name != "" ? var.key_pair_name : null

  vpc_security_group_ids = [aws_security_group.web.id]
  iam_instance_profile   = var.enable_iam_role ? aws_iam_instance_profile.ec2_profile[0].name : null

  user_data = base64encode(file("${path.module}/user_data.sh"))

  # EBS optimization (if instance type supports it)
  ebs_optimized = var.enable_ebs_optimized

  # Disable IMDSv1, enforce IMDSv2
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = true
  }

  # Enable detailed monitoring if requested
  monitoring = var.enable_monitoring

  tags = {
    Name = "${var.project_name}-web-server"
  }
}

# CloudWatch Alarm for CPU Utilization
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count               = var.enable_monitoring ? 1 : 0
  alarm_name          = "${var.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors ec2 cpu utilization"
  treat_missing_data  = "breaching"

  dimensions = {
    InstanceId = aws_instance.web_server.id
  }

  tags = {
    Name = "${var.project_name}-high-cpu-alarm"
  }
}

# CloudWatch Alarm for Instance Status Check
resource "aws_cloudwatch_metric_alarm" "instance_status_check" {
  count               = var.enable_monitoring ? 1 : 0
  alarm_name          = "${var.project_name}-instance-status-check"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "This metric monitors ec2 instance status check"
  treat_missing_data  = "breaching"

  dimensions = {
    InstanceId = aws_instance.web_server.id
  }

  tags = {
    Name = "${var.project_name}-status-check-alarm"
  }
}

