#!/bin/bash

FILE_PATH="/etc/letsencrypt/live/dault.ca/privkey.pem"
LOG_FILE="/var/log/certificate_check.log"

# Function to log messages
log_message() {
    local timestamp=$(date +"%Y-%m-%d %T")
    echo "[$timestamp] $1" >> "$LOG_FILE"
}
# Check if certificate file was modified today
MOD_DATE=$(date -r "$FILE_PATH" +%Y-%m-%d)
TODAY=$(date +%Y-%m-%d)

log_message "Starting certificate check script"
if [ "$MOD_DATE" == "$TODAY" ]; then
    log_message "*****  The cert was modified today."
    scp /etc/letsencrypt/live/dault.ca/privkey.pem root@192.168.1.1:/data/unifi-core/config/unifi-core.key.test
    scp /etc/letsencrypt/live/dault.ca/fullchain.pem root@192.168.1.1:/data/unifi-core/config/unifi-core.crt.test
    ssh root@192.168.1.1 chmod a+r /data/unifi-core/config/unifi-core.crt.test
    ssh root@192.168.1.1 systemctl reload unifi-core
else
    log_message "The cert was not modified today."
fi
log_message "=================================================="
