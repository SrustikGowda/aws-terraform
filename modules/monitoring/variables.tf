variable "project_name" {
  type        = string
  description = "Project name for resource tagging"
}

variable "instance_id" {
  type        = string
  description = "EC2 instance ID to monitor"
}

variable "enable_monitoring" {
  type        = bool
  default     = true
  description = "Enable CloudWatch monitoring and alarms"
}

