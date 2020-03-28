#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

echo 'Setting up reflector'
cp -R $UPLOAD_FILES/auto-reflector /usr/share/
chmod 555 /usr/share/auto-reflector
chmod 440 /usr/share/auto-reflector/*
chmod 555 /usr/share/auto-reflector/auto-reflector.sh
ln -sf /usr/share/auto-reflector/mirrorupgrade.hook /etc/pacman.d/hooks/50-mirrorupgrade.hook
ln -sf /usr/share/auto-reflector/reflector.service /usr/lib/systemd/system/reflector.service
ln -sf /usr/share/auto-reflector/reflector.timer /usr/lib/systemd/system/reflector.timer
ln -sf /usr/share/auto-reflector/auto-reflector.sh /usr/sbin/auto-reflector
systemctl enable reflector.timer
auto-reflector
pacman -Syyuu --noconfirm
