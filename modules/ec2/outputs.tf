output "instance_id" {
  value       = aws_instance.web_server.id
  description = "ID of the EC2 instance"
}

output "instance_arn" {
  value       = aws_instance.web_server.arn
  description = "ARN of the EC2 instance"
}

output "instance_public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "Public IP address of the EC2 instance"
}

output "instance_public_dns" {
  value       = aws_instance.web_server.public_dns
  description = "Public DNS name of the EC2 instance"
}

