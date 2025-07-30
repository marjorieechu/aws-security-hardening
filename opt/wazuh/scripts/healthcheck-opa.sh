#!/bin/bash

CONTAINER_NAME="opa"

# Optional: Check if OPA is serving policy endpoints
if curl -sf http://localhost:8181/health | grep -q 'healthy'; then
  echo "✅ OPA is healthy."
  exit 0
else
  echo "❌ OPA is unhealthy or not running."
  exit 1
fi
