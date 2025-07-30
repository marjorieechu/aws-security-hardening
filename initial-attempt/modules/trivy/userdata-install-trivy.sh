#!/bin/bash

# Update system
apt-get update -y

# Install dependencies
apt-get install -y curl unzip jq awscli

# Install Trivy
curl -sfL https://github.com/aquasecurity/trivy/releases/latest/download/trivy-linux-amd64.tar.gz | tar -xzv -C /usr/local/bin

# Create a basic scan script
mkdir -p /opt/trivy/scans

cat <<EOF > /opt/trivy/scans/scan.sh
#!/bin/bash

# ECR Scan Example: Replace with your ECR URL
ECR_REPO="aws_account_id.dkr.ecr.region.amazonaws.com/repository"
IMAGE_TAG="latest"

# Scan image from ECR
trivy image \$ECR_REPO:\$IMAGE_TAG --format json --output /opt/trivy/scans/scan_report.json

# You can add other actions such as sending notifications or storing reports in S3 here
EOF

# Make the scan script executable
chmod +x /opt/trivy/scans/scan.sh

# Schedule the scan to run daily using cron
(crontab -l 2>/dev/null; echo "0 2 * * * /opt/trivy/scans/scan.sh") | crontab -
