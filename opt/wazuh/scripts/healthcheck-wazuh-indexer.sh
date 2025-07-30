#!/bin/bash

# If running in Docker, adjust the container name accordingly
CONTAINER_NAME="wazuh-indexer"

# Check container is running
if ! docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" | grep -q "$CONTAINER_NAME"; then
  echo "❌ Wazuh Indexer container is not running."
  exit 1
fi

# Check HTTP availability on the exposed port
INDEXER_HOST="https://localhost:9200"
AUTH_USER="admin"
AUTH_PASS="SecretPassword"

# Use curl to check if Wazuh Indexer responds to _cluster/health
if curl -sk -u "$AUTH_USER:$AUTH_PASS" "$INDEXER_HOST/_cluster/health" | grep -q '"status":"green"\|"status":"yellow"'; then
  echo "✅ Wazuh Indexer is healthy."
  exit 0
else
  echo "❌ Wazuh Indexer is unresponsive or unhealthy."
  exit 1
fi
