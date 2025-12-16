# GitHub Actions Setup Guide

This guide will help you set up GitHub Actions for automated Terraform deployments.

## Prerequisites

- AWS Account with appropriate permissions
- GitHub repository with Actions enabled
- AWS CLI installed (for creating IAM user)

## Step 1: Create AWS IAM User

Create a dedicated IAM user for GitHub Actions with the necessary permissions.

### Option A: Using AWS CLI

```bash
# Create IAM user
aws iam create-user --user-name github-actions-terraform

# Create access key
aws iam create-access-key --user-name github-actions-terraform
```

**Save the output** - you'll need the `AccessKeyId` and `SecretAccessKey`.

### Option B: Using AWS Console

1. Go to [IAM Console](https://console.aws.amazon.com/iam/)
2. Click **Users** → **Create user**
3. Username: `github-actions-terraform`
4. Click **Next** → **Create user**
5. Click on the user → **Security credentials** tab
6. Click **Create access key** → **Application running outside AWS**
7. **Save the credentials** (you won't be able to see the secret key again)

## Step 2: Attach IAM Policies

Attach the required policies to the IAM user.

### Option A: Using AWS CLI

```bash
# Attach policies
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

### Option B: Using AWS Console

1. Go to IAM → Users → `github-actions-terraform`
2. Click **Add permissions** → **Attach policies directly**
3. Search and select:
   - `AmazonEC2FullAccess`
   - `CloudWatchFullAccess`
   - `AmazonS3FullAccess`
   - `AmazonDynamoDBFullAccess`
4. Click **Next** → **Add permissions**

### ⚠️ Security Best Practice: Custom IAM Policy

Instead of full access policies, create a custom policy with least privilege:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "cloudwatch:*",
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "*"
    }
  ]
}
```

## Step 3: Add Secrets to GitHub

1. **Navigate to Repository:**
   - Go to your GitHub repository
   - Click **Settings** (top menu)

2. **Access Secrets:**
   - In the left sidebar, click **Secrets and variables** → **Actions**

3. **Add AWS_ACCESS_KEY_ID:**
   - Click **New repository secret**
   - **Name:** `AWS_ACCESS_KEY_ID`
   - **Secret:** Paste your AWS Access Key ID
   - Click **Add secret**

4. **Add AWS_SECRET_ACCESS_KEY:**
   - Click **New repository secret** again
   - **Name:** `AWS_SECRET_ACCESS_KEY`
   - **Secret:** Paste your AWS Secret Access Key
   - Click **Add secret**

5. **Verify:**
   - You should see both secrets listed
   - Secrets are encrypted and cannot be viewed after creation

## Step 4: Test the Workflow

1. **Push to Repository:**
   ```bash
   git add .
   git commit -m "Configure GitHub Actions"
   git push origin main
   ```

2. **Check Workflow:**
   - Go to **Actions** tab in your repository
   - You should see the workflow running
   - The workflow will validate secrets before attempting to use them

## Troubleshooting

### Error: "Credentials could not be loaded"

**Solution:** 
- Verify secrets are correctly named: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
- Check that secrets are added in **Settings** → **Secrets and variables** → **Actions** (not Environment secrets)
- Ensure there are no extra spaces in secret values

### Error: "Access Denied"

**Solution:**
- Verify IAM user has the required permissions
- Check that policies are attached correctly
- Ensure the access key is active (not disabled)

### Error: "Invalid credentials"

**Solution:**
- Verify the access key ID and secret key are correct
- Check that the IAM user exists and is active
- Ensure credentials haven't been rotated

## Security Best Practices

1. **Use Least Privilege:** Create custom IAM policies with only required permissions
2. **Rotate Credentials:** Regularly rotate access keys
3. **Monitor Usage:** Enable CloudTrail to monitor API calls
4. **Use OIDC (Advanced):** For better security, consider using OIDC instead of access keys
5. **Environment Protection:** Use GitHub Environments for production deployments

## Next Steps

After setting up secrets:
- The workflow will automatically run on pushes to `main`
- Pull requests will run validation and planning
- Check the **Actions** tab to monitor workflow runs

For more information, see the [main README.md](README.md).

