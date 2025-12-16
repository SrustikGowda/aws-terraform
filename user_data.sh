#!/bin/bash

# Update system packages
apt-get update -y
apt-get upgrade -y

# Install NGINX
apt-get install -y nginx

# Install additional tools
apt-get install -y curl wget unzip

# Start and enable NGINX
systemctl start nginx
systemctl enable nginx

# Create a simple index page
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terraform Managed EC2 Instance</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
        }
        .container {
            text-align: center;
            padding: 2rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            max-width: 600px;
        }
        h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        .subtitle {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }
        .info {
            background: rgba(255, 255, 255, 0.2);
            padding: 1.5rem;
            border-radius: 10px;
            margin: 1rem 0;
        }
        .info-item {
            margin: 0.5rem 0;
            font-size: 1rem;
        }
        .status {
            display: inline-block;
            padding: 0.5rem 1rem;
            background: rgba(76, 175, 80, 0.8);
            border-radius: 20px;
            margin-top: 1rem;
            font-weight: bold;
        }
        .footer {
            margin-top: 2rem;
            font-size: 0.9rem;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Terraform Managed EC2</h1>
        <p class="subtitle">Infrastructure as Code Successfully Deployed!</p>
        
        <div class="info">
            <div class="info-item"><strong>Instance Type:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-type)</div>
            <div class="info-item"><strong>Instance ID:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</div>
            <div class="info-item"><strong>Availability Zone:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</div>
            <div class="info-item"><strong>Region:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/region)</div>
            <div class="info-item"><strong>Web Server:</strong> NGINX $(nginx -v 2>&1 | cut -d'/' -f2)</div>
        </div>
        
        <div class="status">✅ System Operational</div>
        
        <div class="footer">
            <p>Deployed using Terraform Infrastructure as Code</p>
            <p>Managed by: AWS EC2 + Terraform</p>
        </div>
    </div>
</body>
</html>
EOF

# Set proper permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Log deployment
echo "$(date): Terraform EC2 instance initialized successfully" >> /var/log/user-data.log

