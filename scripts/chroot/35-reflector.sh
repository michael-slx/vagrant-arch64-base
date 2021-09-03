#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

echo '[CHROOT][Reflector] Setting up reflector'
cp $UPLOAD_FILES/reflector/reflector.conf /etc/xdg/reflector/reflector.conf
cp $UPLOAD_FILES/reflector/reflector-firstboot.service /usr/lib/systemd/system/reflector-firstboot.service
systemctl enable reflector.timer reflector-firstboot.service
