#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

echo '[CHROOT][sudo] Configuring sudo'
cp -fR $UPLOAD_FILES/sudo/sudoers /etc/sudoers
chmod 440 /etc/sudoers
