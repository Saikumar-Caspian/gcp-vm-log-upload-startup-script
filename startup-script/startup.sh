#!/bin/bash
set -e

# Redirect all output to a startup log
exec > /var/log/startup-script.log 2>&1

echo "Startup script started at $(date)"

# VARIABLES
BUCKET_NAME="ephemeral-gh-runner-lab-483505-vm-log-bucket"
CUSTOM_LOG_DIR="/var/log/custom"
UPLOAD_SCRIPT="/usr/local/bin/upload_logs.sh"

# Update system
apt-get update -y

# Install required packages
apt-get install -y apt-transport-https ca-certificates gnupg curl cron

# Install Google Cloud CLI
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://packages.cloud.google.com/apt cloud-sdk main" \
  > /etc/apt/sources.list.d/google-cloud-sdk.list
apt-get update -y
apt-get install -y google-cloud-cli

# Create custom log directory
mkdir -p ${CUSTOM_LOG_DIR}
chmod 755 ${CUSTOM_LOG_DIR}

# Generate sample application log
echo "VM booted at $(date)" >> ${CUSTOM_LOG_DIR}/app.log

# Create upload script on VM
cat <<EOF > ${UPLOAD_SCRIPT}
#!/bin/bash
set -euo pipefail

HOSTNAME=\$(hostname)
TIMESTAMP=\$(date +%F-%H%M%S)
CUSTOM_LOG_DIR="/var/log/custom"

if [ -f /var/log/syslog ]; then
  gsutil cp /var/log/syslog \
    gs://${BUCKET_NAME}/\${HOSTNAME}/syslog-\${TIMESTAMP}.log
fi

if [ -d "\$CUSTOM_LOG_DIR" ]; then
  for logfile in \$CUSTOM_LOG_DIR/*.log; do
    [ -e "\$logfile" ] || continue
    gsutil cp "\$logfile" \
      gs://${BUCKET_NAME}/\${HOSTNAME}/
  done
fi
EOF

chmod +x ${UPLOAD_SCRIPT}

# Configure cron job (every 5 minutes)
CRON_JOB="*/5 * * * * root ${UPLOAD_SCRIPT}"

if ! grep -Fxq "${CRON_JOB}" /etc/crontab; then
  echo "${CRON_JOB}" >> /etc/crontab
fi

echo "Startup script completed at $(date)"
