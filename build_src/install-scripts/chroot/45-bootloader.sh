#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

echo 'Installing boot loader'
bootctl --path=/boot install

cp -R $UPLOAD_FILES/loader/** /boot/loader

ROOT_FS_UUID="ROOT"
echo "Setting RootFS Label: $ROOT_FS_UUID"
sed -i "s|FSUUID|$ROOT_FS_UUID|g" /boot/loader/entries/arch.conf
