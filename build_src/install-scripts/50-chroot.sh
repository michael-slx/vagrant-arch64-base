#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$1" ]]; then
  echo "Upload file path missing"
  exit 1
fi
UPLOAD_FILES="$1"

CHROOT_UPLOAD_PATH="/root/upload_files"

echo "Copying setup files to new system"
mkdir -p "/mnt$CHROOT_UPLOAD_PATH"
cp -R $UPLOAD_FILES/* "/mnt$CHROOT_UPLOAD_PATH"

for filename in /tmp/install-scripts/chroot/*; do
  echo "Processing chroot script $filename"
  CHROOT_PATH="$(basename $filename).sh"
  mv "$filename" "/mnt/$CHROOT_PATH"
  arch-chroot /mnt /usr/bin/env bash $CHROOT_PATH "$CHROOT_UPLOAD_PATH"
  rm -f $CHROOT_PATH
done

rm -rf "/mnt$CHROOT_UPLOAD_PATH"
