#!/bin/bash
set -euo pipefail

# VARIABLES
BUCKET_NAME="${BUCKET_NAME}"
HOSTNAME=$(hostname)
TIMESTAMP=$(date +%F-%H%M%S)
CUSTOM_LOG_DIR="/var/log/custom"

# Upload system log
if [ -f /var/log/syslog ]; then
  gsutil cp /var/log/syslog \
    gs://${BUCKET_NAME}/${HOSTNAME}/syslog-${TIMESTAMP}.log
fi

# Upload custom application logs
if [ -d "$CUSTOM_LOG_DIR" ]; then
  for logfile in ${CUSTOM_LOG_DIR}/*.log; do
    [ -e "$logfile" ] || continue
    gsutil cp "$logfile" \
      gs://${BUCKET_NAME}/${HOSTNAME}/
  done
fi
