#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

echo 'Configuring profile defaults'
cp $UPLOAD_FILES/profile/defaults.sh /etc/profile.d/defaults.sh
