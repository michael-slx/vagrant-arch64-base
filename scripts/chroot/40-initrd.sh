#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

echo 'Setting up InitRamFS'
cp -fR $UPLOAD_FILES/initramfs/** /etc/
chmod -R 644 /etc/mkinitcpio*
chmod 755 /etc/mkinitcpio.d
mkinitcpio -P
