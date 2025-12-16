# Terraform Automation for AWS EC2 Infrastructure Deployment

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/features/actions)

> **Infrastructure as Code for Modern Cloud Computing**

This project demonstrates modern Infrastructure-as-Code (IaC) practices using Terraform to automate AWS EC2 instance provisioning. By leveraging Terraform's declarative syntax, we achieve consistency, repeatability, scalability, and cost control across cloud infrastructure deployments.

## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [Configuration](#-configuration)
- [Deployment](#-deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Monitoring & Logging](#-monitoring--logging)
- [Security](#-security)
- [Cost Optimization](#-cost-optimization)
- [Troubleshooting](#-troubleshooting)
- [Best Practices](#-best-practices)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### Infrastructure Automation
- ✅ Fully automated EC2 provisioning via Terraform
- ✅ Infrastructure defined as code (HCL)
- ✅ Modular and reusable module structure
- ✅ Version-controlled infrastructure definitions
- ✅ State management with S3 backend and DynamoDB locking

### CI/CD Integration
- ✅ GitHub Actions pipeline implemented
- ✅ Automated testing and validation
- ✅ Security scanning (Checkov, TFSec)
- ✅ Manual approval gates for safety
- ✅ Automated deployment on merge to main

### Monitoring & Operations
- ✅ CloudWatch integration for metrics
- ✅ Alarm configuration for key metrics
- ✅ Centralized logging setup
- ✅ Cost monitoring dashboards

### Security & Compliance
- ✅ IAM roles with least privilege
- ✅ Security groups with restrictive rules
- ✅ Encrypted state file management
- ✅ Audit trail via CloudTrail
- ✅ Security scanning in CI/CD pipeline

## 🏗️ Architecture

### Infrastructure Components

```
┌─────────────────────────────────────────────────────────┐
│                    AWS Cloud                             │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │              EC2 Instance                        │  │
│  │  ┌────────────────────────────────────────────┐  │  │
│  │  │  Ubuntu 22.04 LTS                         │  │  │
│  │  │  ┌──────────────────────────────────────┐ │  │  │
│  │  │  │  NGINX Web Server                    │ │  │  │
│  │  │  └──────────────────────────────────────┘ │  │  │
│  │  └────────────────────────────────────────────┘  │  │
│  │                                                   │  │
│  │  Security Group                                  │  │
│  │  ├─ SSH (Port 22) - Restricted IP               │  │
│  │  ├─ HTTP (Port 80) - Public                     │  │
│  │  └─ HTTPS (Port 443) - Public                   │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │           CloudWatch Monitoring                   │  │
│  │  ├─ CPU Utilization Alarms                       │  │
│  │  ├─ Instance Status Checks                       │  │
│  │  └─ Custom Metrics                               │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │         S3 Backend (State Storage)               │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │      DynamoDB (State Locking)                    │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### CI/CD Pipeline Architecture

```
┌─────────────────────────────────────────────────────────┐
│              GitHub Repository                          │
│                                                          │
│  Push/PR ──→ ┌────────────────────────────────────┐    │
│              │  1. Lint & Format Check            │    │
│              └────────────────────────────────────┘    │
│                        ↓                                │
│              ┌────────────────────────────────────┐    │
│              │  2. Security Scan (Checkov/TFSec)  │    │
│              └────────────────────────────────────┘    │
│                        ↓                                │
│              ┌────────────────────────────────────┐    │
│              │  3. Terraform Plan                 │    │
│              └────────────────────────────────────┘    │
│                        ↓                                │
│              ┌────────────────────────────────────┐    │
│              │  4. Manual Approval (if required)    │    │
│              └────────────────────────────────────┘    │
│                        ↓                                │
│              ┌────────────────────────────────────┐    │
│              │  5. Terraform Apply                 │    │
│              └────────────────────────────────────┘    │
│                        ↓                                │
│              ┌────────────────────────────────────┐    │
│              │  6. Deployment Summary               │    │
│              └────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

## 📦 Prerequisites

Before you begin, ensure you have the following installed and configured:

### Required Software
- **Terraform** >= 1.0.0 ([Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli))
- **AWS CLI** v2 ([Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))
- **Git** ([Installation Guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git))

### AWS Account Setup
1. **AWS Account** with appropriate permissions
2. **AWS Credentials** configured:
   ```bash
   aws configure
   ```
3. **IAM Permissions** required:
   - EC2 Full Access
   - VPC Read Access
   - CloudWatch Full Access
   - S3 Full Access (for state backend)
   - DynamoDB Full Access (for state locking)

### Backend Infrastructure (One-time Setup)

Before using this Terraform configuration, you need to set up the S3 backend and DynamoDB table for state management:

```bash
# Create S3 bucket for Terraform state
aws s3 mb s3://terraform-state-bucket --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket terraform-state-bucket \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/SrustikGowda/aws-terraform.git
cd aws-terraform
```

### 2. Configure Variables

Copy the example variables file and customize it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values:

```hcl
project_name = "my-terraform-project"
aws_region = "us-east-1"
environment = "dev"
instance_type = "t2.micro"
allowed_ssh_cidr = "YOUR_IP/32"  # Replace with your IP for security
```

**⚠️ Security Note:** Replace `allowed_ssh_cidr` with your actual IP address in CIDR format (e.g., `203.0.113.0/32`). You can find your IP at [whatismyipaddress.com](https://whatismyipaddress.com/).

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Plan

```bash
terraform plan
```

### 5. Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

### 6. Access Your Instance

After deployment, Terraform will output the instance details:

```bash
terraform output
```

Access your web server at the URL provided in the output.

## 📁 Project Structure

```
aws-terraform/
├── .github/
│   └── workflows/
│       └── terraform.yml          # CI/CD pipeline configuration
├── .gitignore                      # Git ignore rules
├── README.md                       # This file
├── data.tf                         # Data sources (AMI lookup, VPC)
├── main.tf                         # Main resources (EC2, Security Group, CloudWatch)
├── outputs.tf                      # Output values
├── provider.tf                    # Provider configuration and backend
├── terraform.tfvars.example        # Example variables file
├── user_data.sh                   # EC2 initialization script
└── variables.tf                   # Input variables
```

## ⚙️ Configuration

### Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `project_name` | Project name for resource tagging | - | ✅ Yes |
| `aws_region` | AWS region for deployment | `us-east-1` | No |
| `environment` | Environment name (dev/staging/prod) | `dev` | No |
| `instance_type` | EC2 instance type | `t2.micro` | No |
| `allowed_ssh_cidr` | CIDR block for SSH access | `0.0.0.0/0` | No |
| `enable_monitoring` | Enable CloudWatch monitoring | `true` | No |
| `volume_size` | EBS volume size in GB | `30` | No |
| `volume_type` | EBS volume type | `gp3` | No |
| `ami_id` | Custom AMI ID (empty = latest Ubuntu) | `""` | No |
| `key_pair_name` | EC2 Key Pair name for SSH | `""` | No |

### Backend Configuration

The backend is configured in `provider.tf` to use:
- **S3 Bucket**: `terraform-state-bucket`
- **State File**: `ec2/terraform.tfstate`
- **DynamoDB Table**: `terraform-locks` (for state locking)
- **Region**: `us-east-1`

To use a different backend, modify the `backend "s3"` block in `provider.tf`.

## 🚢 Deployment

### Manual Deployment

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Plan the deployment:**
   ```bash
   terraform plan -out=tfplan
   ```

3. **Apply the configuration:**
   ```bash
   terraform apply tfplan
   ```

4. **Verify deployment:**
   ```bash
   terraform output
   ```

### Destroying Infrastructure

To tear down all resources:

```bash
terraform destroy
```

**⚠️ Warning:** This will permanently delete all resources created by this configuration.

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

The project includes a comprehensive CI/CD pipeline that:

1. **Lints and validates** Terraform code
2. **Scans for security** vulnerabilities
3. **Plans changes** on pull requests
4. **Applies changes** automatically on merge to main
5. **Provides deployment** summaries

### Setting Up GitHub Actions

#### Step 1: Create AWS IAM User for GitHub Actions

1. **Create IAM User:**
   ```bash
   # Create IAM user
   aws iam create-user --user-name github-actions-terraform
   
   # Create access key
   aws iam create-access-key --user-name github-actions-terraform
   ```

2. **Attach Required Policies:**
   ```bash
   # Attach policies (or create custom policy with least privilege)
   aws iam attach-user-policy \
     --user-name github-actions-terraform \
     --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
   
   aws iam attach-user-policy \
     --user-name github-actions-terraform \
     --policy-arn arn:aws:iam::aws:policy/CloudWatchFullAccess
   
   aws iam attach-user-policy \
     --user-name github-actions-terraform \
     --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
   
   aws iam attach-user-policy \
     --user-name github-actions-terraform \
     --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess
   ```

   **⚠️ Security Best Practice:** Create a custom IAM policy with only the minimum required permissions instead of using full access policies.

#### Step 2: Add AWS Credentials to GitHub Secrets

1. **Navigate to Repository Settings:**
   - Go to your GitHub repository
   - Click **Settings** → **Secrets and variables** → **Actions**

2. **Add Required Secrets:**
   - Click **New repository secret**
   - Add the following secrets:
     - **Name:** `AWS_ACCESS_KEY_ID`
       - **Value:** Your AWS access key ID (from Step 1)
     - **Name:** `AWS_SECRET_ACCESS_KEY`
       - **Value:** Your AWS secret access key (from Step 1)

3. **Verify Secrets:**
   - Ensure both secrets are listed in the repository secrets
   - Secrets are encrypted and only visible during workflow execution

#### Step 3: Workflow Triggers

- **Push to main**: Automatically applies changes
- **Pull Request**: Runs plan and validation (requires secrets)
- **Manual**: Use workflow_dispatch for manual runs

**Note:** The workflow will now validate that secrets are configured before attempting to use AWS credentials, providing clear error messages if they're missing.

### Pipeline Stages

1. **Terraform Lint & Format Check**
   - Validates HCL syntax
   - Checks code formatting
   - Runs TFLint

2. **Security Scan**
   - Checkov security scanning
   - TFSec security scanning

3. **Terraform Plan** (on PRs)
   - Creates execution plan
   - Comments on PR with plan details

4. **Terraform Apply** (on main branch)
   - Applies infrastructure changes
   - Outputs deployment summary

## 📊 Monitoring & Logging

### CloudWatch Metrics

The infrastructure automatically sets up CloudWatch alarms for:

- **CPU Utilization**: Alerts when CPU exceeds 80%
- **Instance Status Check**: Monitors instance health

### Viewing Metrics

```bash
# View CloudWatch alarms
aws cloudwatch describe-alarms --alarm-name-prefix <project-name>

# View instance metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=<instance-id> \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-01-01T23:59:59Z \
  --period 3600 \
  --statistics Average
```

### Logs

- **User Data Logs**: `/var/log/user-data.log` on the EC2 instance
- **NGINX Logs**: `/var/log/nginx/` on the EC2 instance
- **CloudTrail**: API call audit trail in AWS CloudTrail

## 🔒 Security

### Security Best Practices Implemented

1. **Network Security**
   - Security groups with restrictive rules
   - SSH access limited to specific IP (configurable)
   - HTTP/HTTPS access from anywhere (web server)

2. **Data Encryption**
   - EBS volumes encrypted at rest
   - S3 state bucket with encryption enabled
   - TLS/HTTPS for data in transit

3. **Access Control**
   - IAM roles with least privilege
   - State file locking via DynamoDB
   - Secure credential management

4. **Security Scanning**
   - Automated security scans in CI/CD
   - Checkov and TFSec integration
   - Regular dependency updates

### Security Recommendations

1. **SSH Access**: Always restrict SSH to your IP address:
   ```hcl
   allowed_ssh_cidr = "YOUR_IP/32"
   ```

2. **Key Pairs**: Use EC2 Key Pairs for SSH access:
   ```hcl
   key_pair_name = "your-key-pair-name"
   ```

3. **Secrets Management**: Never commit sensitive data:
   - Use `terraform.tfvars` (not in git)
   - Use AWS Secrets Manager for sensitive data
   - Use GitHub Secrets for CI/CD

4. **Regular Updates**: Keep Terraform and providers updated

## 💰 Cost Optimization

### Cost Estimation

| Resource | Free Tier | Monthly Cost (Post-Free Tier) |
|----------|-----------|-------------------------------|
| t2.micro EC2 | ✅ 750 hours/month | ~$7.30 |
| EBS Storage (30GB) | ✅ 30GB | ~$3.00 |
| Data Transfer (in) | ✅ Free | Free |
| Data Transfer (out) | ✅ 1GB free | ~$0.09/GB |
| CloudWatch | ✅ Basic monitoring free | ~$0.50 |
| **Total (Free Tier)** | **$0.00** | **~$10-15/month** |

### Cost Optimization Strategies

1. **Use Free Tier**: t2.micro instances are free for 12 months
2. **Reserved Instances**: Save 20-40% with 1-year commitments
3. **Spot Instances**: Save 70-90% for fault-tolerant workloads
4. **Auto-scaling**: Scale down during off-hours
5. **Resource Tagging**: Track costs by project/environment

### Monitoring Costs

```bash
# View cost and usage reports
aws ce get-cost-and-usage \
  --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity MONTHLY \
  --metrics BlendedCost
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Backend Configuration Error

**Error**: `Error: Failed to get existing workspaces`

**Solution**: Ensure S3 bucket and DynamoDB table exist:
```bash
aws s3 ls s3://terraform-state-bucket
aws dynamodb describe-table --table-name terraform-locks
```

#### 2. Instance Not Accessible

**Error**: Cannot SSH or access web server

**Solution**:
- Check security group rules
- Verify your IP is in `allowed_ssh_cidr`
- Check instance status: `aws ec2 describe-instance-status --instance-ids <id>`

#### 3. Terraform State Lock

**Error**: `Error acquiring the state lock`

**Solution**: If lock is stuck, force unlock (use with caution):
```bash
terraform force-unlock <LOCK_ID>
```

#### 4. AMI Not Found

**Error**: `Error: Your query returned no results`

**Solution**: Update the AMI filter in `data.tf` or specify a custom `ami_id`

### Debugging Commands

```bash
# Check Terraform version
terraform version

# Validate configuration
terraform validate

# Check AWS credentials
aws sts get-caller-identity

# View instance logs
aws ec2 get-console-output --instance-id <instance-id>

# SSH into instance (if key pair configured)
ssh -i <key.pem> ubuntu@<public-ip>
```

## 📚 Best Practices

### Infrastructure as Code

1. **Version Control**: Always commit infrastructure code
2. **State Management**: Use remote state (S3 + DynamoDB)
3. **State Locking**: Prevent concurrent modifications
4. **Modularity**: Break down into reusable modules
5. **Documentation**: Document all resources and variables

### Terraform Workflow

1. **Write** → Write Terraform configuration
2. **Init** → Initialize Terraform
3. **Validate** → Validate syntax
4. **Plan** → Review changes
5. **Apply** → Deploy infrastructure
6. **Destroy** → Clean up when done

### Security

1. **Least Privilege**: Grant minimum required permissions
2. **Secrets Management**: Never commit secrets
3. **Network Security**: Restrict access appropriately
4. **Encryption**: Encrypt data at rest and in transit
5. **Audit**: Enable CloudTrail logging

### Cost Management

1. **Tagging**: Tag all resources for cost tracking
2. **Monitoring**: Set up cost alerts
3. **Review**: Regularly review and optimize
4. **Cleanup**: Destroy unused resources

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines

- Follow Terraform best practices
- Update documentation for new features
- Add tests where applicable
- Ensure all CI/CD checks pass

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [HashiCorp Terraform](https://www.terraform.io/) for the amazing IaC tool
- [AWS](https://aws.amazon.com/) for cloud infrastructure
- [GitHub Actions](https://github.com/features/actions) for CI/CD automation

## 📞 Support

For issues, questions, or contributions:

- **Issues**: [GitHub Issues](https://github.com/SrustikGowda/aws-terraform/issues)
- **Discussions**: [GitHub Discussions](https://github.com/SrustikGowda/aws-terraform/discussions)

## 🔮 Future Enhancements

- [ ] Multi-region deployment
- [ ] Database integration (RDS/Aurora)
- [ ] Lambda function integration
- [ ] API Gateway setup
- [ ] Advanced monitoring (APM, distributed tracing)
- [ ] Web Application Firewall (WAF)
- [ ] Auto-scaling groups
- [ ] Load balancer integration
- [ ] Multi-AZ deployment
- [ ] Disaster recovery setup

---

**Made with ❤️ using Terraform and AWS**

*Last updated: 2024*
