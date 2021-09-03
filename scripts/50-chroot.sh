#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$1"
FILES_DIR="$2"

CHROOT_UPLOAD_PATH="/root/setup_files"

echo "Copying setup files to new system"
mkdir -p "/mnt$CHROOT_UPLOAD_PATH"
cp -R $FILES_DIR/* "/mnt$CHROOT_UPLOAD_PATH"

for filename in $SCRIPT_DIR/chroot/*; do
  echo "Processing chroot script $filename"
  CHROOT_PATH="$(basename $filename).sh"
  mv "$filename" "/mnt/$CHROOT_PATH"
  arch-chroot /mnt /usr/bin/env bash $CHROOT_PATH "$CHROOT_UPLOAD_PATH"
  rm -f $CHROOT_PATH
done

rm -rf "/mnt$CHROOT_UPLOAD_PATH"
