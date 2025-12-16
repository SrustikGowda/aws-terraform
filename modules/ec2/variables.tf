variable "project_name" {
  type        = string
  description = "Project name for resource tagging"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_pair_name" {
  type        = string
  default     = ""
  description = "EC2 Key Pair name for SSH access"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach"
}

variable "user_data" {
  type        = string
  description = "User data script for instance initialization"
}

variable "enable_iam_role" {
  type        = bool
  default     = false
  description = "Enable IAM role for EC2 instance"
}

variable "enable_ebs_optimized" {
  type        = bool
  default     = false
  description = "Enable EBS optimization"
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

variable "enable_monitoring" {
  type        = bool
  default     = true
  description = "Enable detailed monitoring"
}

