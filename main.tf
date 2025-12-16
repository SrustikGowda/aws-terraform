# Security Group Module
module "security_group" {
  source = "./modules/security-group"

  project_name       = var.project_name
  vpc_id             = data.aws_vpc.default.id
  allowed_ssh_cidr   = var.allowed_ssh_cidr
  allow_http_public  = var.allow_http_public
  allow_https_public = var.allow_https_public
}

# EC2 Instance Module
module "ec2" {
  source = "./modules/ec2"

  project_name         = var.project_name
  ami_id               = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type        = var.instance_type
  key_pair_name        = var.key_pair_name
  security_group_ids   = [module.security_group.security_group_id]
  user_data            = base64encode(file("${path.module}/scripts/user_data.sh"))
  enable_iam_role      = var.enable_iam_role
  enable_ebs_optimized = var.enable_ebs_optimized
  volume_size          = var.volume_size
  volume_type          = var.volume_type
  enable_monitoring    = var.enable_monitoring
}

# Monitoring Module
module "monitoring" {
  source = "./modules/monitoring"

  project_name      = var.project_name
  instance_id       = module.ec2.instance_id
  enable_monitoring = var.enable_monitoring
}
