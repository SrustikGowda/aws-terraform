output "security_group_id" {
  value       = aws_security_group.web.id
  description = "ID of the security group"
}

output "security_group_name" {
  value       = aws_security_group.web.name
  description = "Name of the security group"
}

