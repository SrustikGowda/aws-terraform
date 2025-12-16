# IAM Role for EC2 Instance (optional)
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
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name != "" ? var.key_pair_name : null

  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.enable_iam_role ? aws_iam_instance_profile.ec2_profile[0].name : null

  user_data = var.user_data

  ebs_optimized = var.enable_ebs_optimized

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

  monitoring = var.enable_monitoring

  tags = {
    Name = "${var.project_name}-web-server"
  }
}

