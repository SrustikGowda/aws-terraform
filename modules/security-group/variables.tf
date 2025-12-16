variable "project_name" {
  type        = string
  description = "Project name for resource tagging"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where security group will be created"
}

variable "allowed_ssh_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR block allowed for SSH access"
}

variable "allow_http_public" {
  type        = bool
  default     = true
  description = "Allow HTTP access from public internet"
}

variable "allow_https_public" {
  type        = bool
  default     = true
  description = "Allow HTTPS access from public internet"
}

