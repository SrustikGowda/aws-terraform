variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type (t3.micro is free tier eligible in us-east-1)"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for resource deployment"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name (dev, staging, prod)"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  type        = string
  default     = "aws-terraform-project"
  description = "Project name for resource tagging and naming"
}

variable "allowed_ssh_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR block allowed for SSH access (use YOUR_IP/32 for security)"
}

variable "enable_monitoring" {
  type        = bool
  default     = true
  description = "Enable CloudWatch monitoring and alarms"
}

variable "volume_size" {
  type        = number
  default     = 30
  description = "EBS volume size in GB"
}

variable "volume_type" {
  type        = string
  default     = "gp3"
  description = "EBS volume type"
}

variable "ami_id" {
  type        = string
  default     = ""
  description = "Custom AMI ID (leave empty to use latest Ubuntu AMI)"
}

variable "key_pair_name" {
  type        = string
  default     = ""
  description = "EC2 Key Pair name for SSH access (optional)"
}

variable "allow_http_public" {
  type        = bool
  default     = true
  description = "Allow HTTP (port 80) access from public internet"
}

variable "allow_https_public" {
  type        = bool
  default     = true
  description = "Allow HTTPS (port 443) access from public internet"
}

variable "enable_ebs_optimized" {
  type        = bool
  default     = false
  description = "Enable EBS optimization (only supported on certain instance types)"
}

variable "enable_iam_role" {
  type        = bool
  default     = false
  description = "Enable IAM role for EC2 instance (requires IAM permissions)"
}

