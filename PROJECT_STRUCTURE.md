# Project Structure

This document explains the organization of the Terraform project.

## Directory Structure

```
aws-terraform/
├── .github/
│   └── workflows/
│       └── terraform.yml          # CI/CD pipeline
│
├── modules/                        # Reusable Terraform modules
│   ├── ec2/                       # EC2 instance module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security-group/              # Security group module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── monitoring/                 # CloudWatch monitoring module
│       ├── main.tf
│       └── variables.tf
│
├── scripts/                        # Helper scripts
│   ├── user_data.sh               # EC2 initialization script
│   └── setup-backend.sh            # Backend setup script
│
├── docs/                           # Documentation
│   ├── GITHUB_ACTIONS_SETUP.md
│   ├── HOW_TO_VIEW_RESOURCES.md
│   ├── SETUP_S3_BACKEND.md
│   └── ...
│
├── Root Level Configuration Files:
│   ├── provider.tf                 # AWS provider and backend config
│   ├── variables.tf                # Input variables
│   ├── data.tf                     # Data sources (AMI, VPC)
│   ├── main.tf                     # Main configuration (uses modules)
│   ├── outputs.tf                  # Output values
│   ├── terraform.tfvars.example    # Example variables file
│   ├── .gitignore                  # Git ignore rules
│   └── README.md                   # Main documentation
│
└── Other Files:
    ├── Terraform_AWS_Complete.pdf  # Project PDF
    └── dontcommit.txt              # Local file (not committed)
```

## Module Organization

### modules/ec2/
Contains EC2 instance resources:
- EC2 instance
- IAM role and instance profile (optional)
- EBS configuration

### modules/security-group/
Contains security group resources:
- Ingress rules (SSH, HTTP, HTTPS)
- Egress rules (restricted)

### modules/monitoring/
Contains CloudWatch resources:
- CPU utilization alarms
- Instance status check alarms

## Benefits of This Structure

1. **Modularity**: Each component is in its own module
2. **Reusability**: Modules can be reused in other projects
3. **Maintainability**: Easier to find and update specific components
4. **Scalability**: Easy to add new modules or environments
5. **Organization**: Clear separation of concerns

## Usage

The root `main.tf` file uses these modules to compose the complete infrastructure:

```hcl
module "security_group" { ... }
module "ec2" { ... }
module "monitoring" { ... }
```

This makes the root configuration clean and easy to understand.

