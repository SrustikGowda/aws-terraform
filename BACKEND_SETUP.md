# Simple Backend Setup (For College Projects)

## Option 1: Use Local Backend (Simplest - Recommended for Learning)

The configuration is already set to use local backend by default. Just run:

```bash
terraform init
terraform plan
terraform apply
```

The state file will be saved locally as `terraform.tfstate`.

## Option 2: Use S3 Backend (For Production)

If you want to use S3 backend, you need to:

1. **Create S3 Bucket:**
   ```bash
   aws s3 mb s3://terraform-state-bucket --region us-east-1
   ```

2. **Create DynamoDB Table:**
   ```bash
   aws dynamodb create-table \
     --table-name terraform-locks \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --billing-mode PAY_PER_REQUEST \
     --region us-east-1
   ```

3. **Uncomment the backend block in provider.tf:**
   - Remove the `#` comments from the `backend "s3"` block
   - Comment out or remove the local backend comment

4. **Re-initialize:**
   ```bash
   terraform init
   ```

## Current Setup

The project is configured to use **local backend** by default, which is perfect for learning and college projects.

