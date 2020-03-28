#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

echo 'Installing boot loader'
bootctl --path=/boot install

cp -fR $UPLOAD_FILES/pacman-hooks/systemd-boot.hook /etc/pacman.d/hooks/100-systemd-boot.hook
cp -R $UPLOAD_FILES/loader/** /boot/loader

ROOT_FS_UUID="$(blkid -s UUID -o value /dev/sda2)"
echo "Setting RootFS UUID: $ROOT_FS_UUID"
sed -i "s|FSUUID|$ROOT_FS_UUID|g" /boot/loader/entries/arch.conf
sed -i "s|FSUUID|$ROOT_FS_UUID|g" /boot/loader/entries/arch-fallback.conf
