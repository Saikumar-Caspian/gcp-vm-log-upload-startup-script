#!/bin/bash
set -e

exec > /var/log/startup-script.log 2>&1

echo "Startup script started at $(date)"

BUCKET_NAME="ephemeral-gh-runner-lab-483505-vm-log-bucket"
CUSTOM_LOG_DIR="/var/log/custom"
UPLOAD_SCRIPT="/usr/local/bin/upload_logs.sh"

apt-get update -y
apt-get install -y curl cron gnupg ca-certificates

# Install Google Cloud CLI (safe method for Ubuntu 22.04)
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
  | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] \
https://packages.cloud.google.com/apt cloud-sdk main" \
> /etc/apt/sources.list.d/google-cloud-sdk.list

apt-get update -y
apt-get install -y google-cloud-cli

mkdir -p ${CUSTOM_LOG_DIR}
chmod 755 ${CUSTOM_LOG_DIR}

echo "VM booted at $(date)" >> ${CUSTOM_LOG_DIR}/app.log

cat <<EOF > ${UPLOAD_SCRIPT}
#!/bin/bash
set -euo pipefail

HOSTNAME=\$(hostname)
TIMESTAMP=\$(date +%F-%H%M%S)

if [ -f /var/log/syslog ]; then
  gsutil cp /var/log/syslog \
    gs://${BUCKET_NAME}/\${HOSTNAME}/syslog-\${TIMESTAMP}.log
fi

if [ -d "/var/log/custom" ]; then
  for logfile in /var/log/custom/*.log; do
    [ -e "\$logfile" ] || continue
    gsutil cp "\$logfile" \
      gs://${BUCKET_NAME}/\${HOSTNAME}/
  done
fi
EOF

chmod +x ${UPLOAD_SCRIPT}

CRON_JOB="*/5 * * * * root ${UPLOAD_SCRIPT}"
grep -Fxq "$CRON_JOB" /etc/crontab || echo "$CRON_JOB" >> /etc/crontab

echo "Startup script completed at $(date)"

