#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

echo 'Configuring SSH'
cp -fR $UPLOAD_FILES/ssh/sshd_config /etc/ssh/sshd_config
chmod 640 /etc/ssh/sshd_config
systemctl enable sshd
