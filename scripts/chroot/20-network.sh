#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

echo '[CHROOT][Network] Configuring hostname and hosts file'
echo 'vagrant' > /etc/hostname
echo '127.0.0.1   localhost' >> /etc/hosts
echo '::1		      localhost' >> /etc/hosts

echo '[CHROOT][Network] Configuring networkd'
cp -f $UPLOAD_FILES/networkd/** /etc/systemd/network/
systemctl enable systemd-networkd.service systemd-resolved.service
