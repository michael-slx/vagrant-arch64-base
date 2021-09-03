#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

echo '[CHROOT][Profile] Configuring profile defaults'
cp $UPLOAD_FILES/profile/defaults.sh /etc/profile.d/defaults.sh
cp $UPLOAD_FILES/profile/xdg.sh /etc/profile.d/xdg.sh
