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
    InstanceId = var.instance_id
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
    InstanceId = var.instance_id
  }

  tags = {
    Name = "${var.project_name}-status-check-alarm"
  }
}

