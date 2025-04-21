#!/bin/bash

# Update and install dependencies
apt-get update -y
apt-get install -y python3 python3-pip unzip awscli

# Install Cloud Custodian
pip3 install c7n

# Setup basic policy
mkdir -p /opt/custodian/policies

cat <<EOF > /opt/custodian/policies/stop-unused-instances.yml
policies:
  - name: stop-unused-instances
    resource: ec2
    filters:
      - type: instance-age
        days: 30
    actions:
      - stop
EOF

# Create a cron job to run it daily
(crontab -l 2>/dev/null; echo \"0 1 * * * c7n run -s /opt/custodian/output /opt/custodian/policies/stop-unused-instances.yml\") | crontab -
