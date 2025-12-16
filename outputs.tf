output "instance_public_ip" {
  value       = module.ec2.instance_public_ip
  description = "Public IP address of the EC2 instance"
}

output "instance_public_dns" {
  value       = module.ec2.instance_public_dns
  description = "Public DNS name of the EC2 instance"
}

output "instance_id" {
  value       = module.ec2.instance_id
  description = "ID of the EC2 instance"
}

output "instance_arn" {
  value       = module.ec2.instance_arn
  description = "ARN of the EC2 instance"
}

output "security_group_id" {
  value       = module.security_group.security_group_id
  description = "ID of the security group"
}

output "security_group_name" {
  value       = module.security_group.security_group_name
  description = "Name of the security group"
}

output "instance_url" {
  value       = "http://${module.ec2.instance_public_ip}"
  description = "URL to access the web server"
}

output "ssh_command" {
  value       = "ssh -i <your-key.pem> ubuntu@${module.ec2.instance_public_ip}"
  description = "SSH command to connect to the instance"
}

output "ami_id_used" {
  value       = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu.id
  description = "AMI ID used for the instance"
}
