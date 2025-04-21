#!/bin/bash

# Update system and install dependencies
apt-get update
apt-get install -y curl apt-transport-https lsb-release gnupg

# Install Wazuh repository and GPG key
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee /etc/apt/sources.list.d/wazuh.list

# Install Wazuh manager
apt-get update
apt-get install -y wazuh-manager

# Install Elasticsearch (Wazuh depends on it)
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.2-amd64.deb
dpkg -i elasticsearch-7.10.2-amd64.deb
systemctl enable elasticsearch
systemctl start elasticsearch

# Install Kibana
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.10.2-amd64.deb
dpkg -i kibana-7.10.2-amd64.deb
systemctl enable kibana
systemctl start kibana

# Install Wazuh Kibana plugin
/var/ossec/bin/manager-auth -m wazuh-manager
/opt/kibana/bin/kibana-plugin install https://github.com/wazuh/wazuh-kibana-plugin/releases/download/4.2.0/wazuh-kibana-plugin-4.2.0.zip

# Start Wazuh manager service
systemctl enable wazuh-manager
systemctl start wazuh-manager

# Enable and start Wazuh agent (for monitoring)
systemctl enable wazuh-agent
systemctl start wazuh-agent

# Configure firewall
ufw allow 5601/tcp
ufw allow 1514/tcp
ufw enable
