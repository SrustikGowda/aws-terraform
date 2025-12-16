resource "aws_security_group" "web" {
  name_prefix = "${var.project_name}-web-sg-"
  description = "Security group for web server - allows HTTP and SSH"
  vpc_id      = var.vpc_id

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
  egress {
    description = "HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP outbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

