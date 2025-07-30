#!/bin/bash

# Basic health check for Filebeat — ensures it is running and logs are accessible
FILEBEAT_PID=$(pgrep filebeat)
LOG_TEST=$(ls /var/log/zeek/current/*.log 2>/dev/null | head -n 1)

if [[ -n "$FILEBEAT_PID" && -n "$LOG_TEST" ]]; then
    exit 0
else
    exit 1
fi

# chmod +x /opt/wazuh/scripts/healthcheck-*.sh

