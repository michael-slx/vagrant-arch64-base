#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

echo 'Setting up reflector'
cp $UPLOAD_FILES/auto-reflector/reflector.conf /etc/xdg/reflector/reflector.conf
cp $UPLOAD_FILES/auto-reflector/mirrorupgrade.hook /etc/pacman.d/hooks/50-mirrorupgrade.hook
systemctl enable reflector.timer
/usr/bin/reflector @/etc/xdg/reflector/reflector.conf
pacman -Syyuu --noconfirm
