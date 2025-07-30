#!/bin/bash

CONTAINER_NAME="zeek"

if docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" | grep -q "$CONTAINER_NAME"; then
  echo "✅ Zeek is running."
  exit 0
else
  echo "❌ Zeek is not running."
  exit 1
fi
