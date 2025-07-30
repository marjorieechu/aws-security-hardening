#!/bin/bash

CONTAINER_NAME="falco"

if docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" | grep -q "$CONTAINER_NAME"; then
  echo "✅ Falco is running."
  exit 0
else
  echo "❌ Falco is not running."
  exit 1
fi
