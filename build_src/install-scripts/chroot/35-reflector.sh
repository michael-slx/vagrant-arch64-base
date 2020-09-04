#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

echo 'Setting up reflector'
cp $UPLOAD_FILES/reflector/reflector.conf /etc/xdg/reflector/reflector.conf
systemctl enable reflector.timer
