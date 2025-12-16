# Quick Setup: S3 Backend for Terraform State

## Why S3 Backend?

For CI/CD workflows to work properly (especially destroy), Terraform needs to share state between runs. Local state doesn't work because each GitHub Actions run gets a fresh environment.

## One-Time Setup (5 minutes)

### Step 1: Create S3 Bucket

```bash
aws s3 mb s3://terraform-state-bucket --region us-east-1
```

### Step 2: Enable Versioning

```bash
aws s3api put-bucket-versioning \
  --bucket terraform-state-bucket \
  --versioning-configuration Status=Enabled
```

### Step 3: Enable Encryption

```bash
aws s3api put-bucket-encryption \
  --bucket terraform-state-bucket \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'
```

### Step 4: Create DynamoDB Table

```bash
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### Step 5: Wait for Table

```bash
aws dynamodb wait table-exists --table-name terraform-locks
```

## That's It!

After running these commands, your Terraform workflows will:
- ✅ Share state between runs
- ✅ Destroy will work correctly
- ✅ Prevent conflicts with state locking

## Or Use the Setup Script

We have a script that does all of this:

```bash
./setup-backend.sh
```

## For Local Development

If you want to use local state for local development, you can comment out the backend block in `provider.tf`, but keep it enabled for CI/CD.

