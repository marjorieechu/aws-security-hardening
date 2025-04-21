#!/bin/bash

# Update system
apt-get update -y

# Install curl and unzip
apt-get install -y curl unzip

# Download and install OPA
curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64
chmod +x opa
mv opa /usr/local/bin/opa

# Create a simple policy
mkdir -p /opt/opa/policies
cat <<EOF > /opt/opa/policies/example.rego
package example

default allow = false

allow {
  input.method = \"GET\"
}
EOF

# Create a systemd service
cat <<EOF > /etc/systemd/system/opa.service
[Unit]
Description=OPA Agent
After=network.target

[Service]
ExecStart=/usr/local/bin/opa run --server --addr :8181 /opt/opa/policies
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Enable and start OPA
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable opa
systemctl start opa
