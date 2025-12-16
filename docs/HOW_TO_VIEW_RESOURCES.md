# How to View Your Terraform Resources in AWS

## Where Resources Are Created

Your infrastructure is created in **AWS (Amazon Web Services)** in the cloud, not on your local computer.

**Default Region:** `us-east-1` (N. Virginia)

## How to View Resources

### 1. Login to AWS Console

1. Go to: https://console.aws.amazon.com/
2. Sign in with your AWS account credentials
3. You'll see the AWS Management Console dashboard

### 2. View EC2 Instance

1. In the AWS Console, search for **"EC2"** in the search bar
2. Click on **EC2** service
3. Click **Instances** in the left sidebar
4. You'll see your instance named: `aws-terraform-project-web-server`
5. You can see:
   - Instance ID
   - Public IP address
   - Instance state (running, stopped, etc.)
   - Instance type (t3.micro)

### 3. View Security Group

1. In EC2 console, click **Security Groups** in the left sidebar
2. Look for security group with name starting with: `aws-terraform-project-web-sg-`
3. You can see:
   - Inbound rules (SSH, HTTP, HTTPS)
   - Outbound rules
   - Security group ID

### 4. View CloudWatch Alarms (if monitoring enabled)

1. Search for **"CloudWatch"** in AWS Console
2. Click **Alarms** in the left sidebar
3. You'll see alarms like:
   - `aws-terraform-project-high-cpu`
   - `aws-terraform-project-instance-status-check`

### 5. Get Instance URL

After deployment, the workflow outputs the instance URL. You can also:

1. Go to EC2 → Instances
2. Click on your instance
3. Copy the **Public IPv4 address**
4. Visit: `http://YOUR_PUBLIC_IP` in your browser

## What Resources Are Created

- **EC2 Instance**: Your web server (Ubuntu with NGINX)
- **Security Group**: Firewall rules for your instance
- **CloudWatch Alarms**: Monitoring for CPU and status checks
- **IAM Role** (optional): If enabled, for EC2 permissions

## Important Notes

- **Root User vs IAM User**: You can login with either root user or IAM user - both can see the resources
- **Region**: Make sure you're viewing the correct region (us-east-1 by default)
- **Cost**: Resources cost money when running (t3.micro is very cheap, ~$0.01/hour)
- **Cleanup**: Use `terraform destroy` to remove all resources and stop charges

## Quick Access Links

- **EC2 Console**: https://console.aws.amazon.com/ec2/
- **CloudWatch**: https://console.aws.amazon.com/cloudwatch/
- **IAM Console**: https://console.aws.amazon.com/iam/

