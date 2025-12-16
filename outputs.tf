output "instance_public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "Public IP address of the EC2 instance"
}

output "instance_public_dns" {
  value       = aws_instance.web_server.public_dns
  description = "Public DNS name of the EC2 instance"
}

output "instance_id" {
  value       = aws_instance.web_server.id
  description = "ID of the EC2 instance"
}

output "instance_arn" {
  value       = aws_instance.web_server.arn
  description = "ARN of the EC2 instance"
}

output "security_group_id" {
  value       = aws_security_group.web.id
  description = "ID of the security group"
}

output "security_group_name" {
  value       = aws_security_group.web.name
  description = "Name of the security group"
}

output "instance_url" {
  value       = "http://${aws_instance.web_server.public_ip}"
  description = "URL to access the web server"
}

output "ssh_command" {
  value       = "ssh -i <your-key.pem> ubuntu@${aws_instance.web_server.public_ip}"
  description = "SSH command to connect to the instance"
}

output "ami_id_used" {
  value       = aws_instance.web_server.ami
  description = "AMI ID used for the instance"
}

