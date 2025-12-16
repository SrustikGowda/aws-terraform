# Quick Start Guide

This guide will help you get up and running with the Terraform AWS EC2 deployment in minutes.

## Prerequisites Checklist

- [ ] AWS Account created
- [ ] AWS CLI installed and configured (`aws configure`)
- [ ] Terraform installed (version >= 1.0)
- [ ] Git installed
- [ ] Your public IP address (for SSH security)

## Step-by-Step Setup

### 1. Clone and Navigate

```bash
git clone https://github.com/SrustikGowda/aws-terraform.git
cd aws-terraform
```

### 2. Setup Backend Infrastructure

Run the setup script to create S3 bucket and DynamoDB table:

```bash
./setup-backend.sh
```

Or manually:

```bash
# Create S3 bucket
aws s3 mb s3://terraform-state-bucket --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Create DynamoDB table
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

### 3. Configure Variables

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

```hcl
project_name = "my-project"
aws_region = "us-east-1"
allowed_ssh_cidr = "YOUR_IP/32"  # Get your IP from whatismyipaddress.com
```

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Review Plan

```bash
terraform plan
```

### 6. Deploy

```bash
terraform apply
```

Type `yes` when prompted.

### 7. Access Your Instance

After deployment, get the instance URL:

```bash
terraform output instance_url
```

Visit the URL in your browser!

### 8. Clean Up (When Done)

```bash
terraform destroy
```

## Common Commands

```bash
# Initialize
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply

# View outputs
terraform output

# Destroy infrastructure
terraform destroy

# Format code
terraform fmt

# Validate code
terraform validate
```

## Troubleshooting

**Backend error?** Make sure S3 bucket and DynamoDB table exist.

**Can't SSH?** Check your IP is in `allowed_ssh_cidr` variable.

**Instance not accessible?** Check security group rules and instance status.

For more details, see the [full README.md](README.md).

