#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

echo 'Configuring pacman'
sed -i '/^#.*Color/s/^#//' /etc/pacman.conf
sed -i '/^#.*CheckSpace/s/^#//' /etc/pacman.conf

mkdir -p /etc/pacman.d/hooks
cp -f $UPLOAD_FILES/pacman-hooks/* /etc/pacman.d/hooks
