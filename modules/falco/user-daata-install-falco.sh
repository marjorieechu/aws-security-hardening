#!/bin/bash

# Update system and install dependencies
apt-get update
apt-get install -y curl gnupg lsb-release

# Add Falco's official repository
curl -s https://packagecloud.io/install/repositories/falcosecurity/falco/script.deb.sh | sudo bash

# Install Falco
apt-get install -y falco

# Start and enable Falco service
systemctl enable falco
systemctl start falco

# Check status of Falco
systemctl status falco

# Enable firewall rules for Falco (optional)
ufw allow 6677/tcp
ufw enable
