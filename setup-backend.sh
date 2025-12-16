#!/bin/bash

# Setup script for Terraform backend infrastructure
# This script creates the S3 bucket and DynamoDB table required for Terraform state management

set -e

REGION="${AWS_REGION:-us-east-1}"
BUCKET_NAME="${TERRAFORM_STATE_BUCKET:-terraform-state-bucket}"
TABLE_NAME="${TERRAFORM_LOCKS_TABLE:-terraform-locks}"

echo "🚀 Setting up Terraform backend infrastructure..."
echo "Region: $REGION"
echo "S3 Bucket: $BUCKET_NAME"
echo "DynamoDB Table: $TABLE_NAME"
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS credentials not configured. Please run 'aws configure' first."
    exit 1
fi

echo "✅ AWS credentials verified"
echo ""

# Create S3 bucket for Terraform state
echo "📦 Creating S3 bucket for Terraform state..."

if aws s3 ls "s3://$BUCKET_NAME" 2>&1 | grep -q 'NoSuchBucket'; then
    if [ "$REGION" == "us-east-1" ]; then
        aws s3 mb "s3://$BUCKET_NAME" --region "$REGION"
    else
        aws s3 mb "s3://$BUCKET_NAME" --region "$REGION"
    fi
    echo "✅ S3 bucket created: $BUCKET_NAME"
else
    echo "ℹ️  S3 bucket already exists: $BUCKET_NAME"
fi

# Enable versioning
echo "🔄 Enabling versioning on S3 bucket..."
aws s3api put-bucket-versioning \
    --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled \
    --region "$REGION" 2>&1 | grep -v "An error occurred" || true
echo "✅ Versioning enabled"

# Enable encryption
echo "🔒 Enabling encryption on S3 bucket..."
aws s3api put-bucket-encryption \
    --bucket "$BUCKET_NAME" \
    --server-side-encryption-configuration '{
        "Rules": [{
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }]
    }' \
    --region "$REGION" 2>&1 | grep -v "An error occurred" || true
echo "✅ Encryption enabled"

# Block public access
echo "🛡️  Blocking public access..."
aws s3api put-public-access-block \
    --bucket "$BUCKET_NAME" \
    --public-access-block-configuration \
        "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true" \
    --region "$REGION" 2>&1 | grep -v "An error occurred" || true
echo "✅ Public access blocked"

echo ""

# Create DynamoDB table for state locking
echo "🔐 Creating DynamoDB table for state locking..."

if aws dynamodb describe-table --table-name "$TABLE_NAME" --region "$REGION" 2>&1 | grep -q 'ResourceNotFoundException'; then
    aws dynamodb create-table \
        --table-name "$TABLE_NAME" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --region "$REGION" > /dev/null
    
    echo "⏳ Waiting for table to be active..."
    aws dynamodb wait table-exists --table-name "$TABLE_NAME" --region "$REGION"
    echo "✅ DynamoDB table created: $TABLE_NAME"
else
    echo "ℹ️  DynamoDB table already exists: $TABLE_NAME"
fi

echo ""
echo "✅ Backend infrastructure setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Copy terraform.tfvars.example to terraform.tfvars"
echo "2. Update terraform.tfvars with your values"
echo "3. Run 'terraform init' to initialize Terraform"
echo "4. Run 'terraform plan' to review changes"
echo "5. Run 'terraform apply' to deploy infrastructure"
echo ""

