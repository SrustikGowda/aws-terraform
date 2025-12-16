terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # S3 backend for remote state (required for CI/CD destroy to work)
  # For local development, you can comment this out and use local state
  # NOTE: Replace YOUR_ACCOUNT_ID with your AWS account ID for unique bucket name
  backend "s3" {
    bucket         = "terraform-state-bucket-386397333158"  # Add your account ID for uniqueness
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-386397333158"  # Add your account ID for uniqueness
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

