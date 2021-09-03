#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$1"
FILES_DIR="$2"

echo "[Disk] Partitioning disk"
sfdisk /dev/sda < $FILES_DIR/disk/disk-parts.dump > /dev/null
sync

echo "[Disk] Creating file systems"
mkfs.fat -F32 -n "EFI" /dev/sda1 > /dev/null
mkfs.ext4 -L "ROOT" /dev/sda2 > /dev/null
mkswap -L "SWAP" /dev/sda3 > /dev/null
sync

echo "[Disk] Mounting file systems"
swapon /dev/sda3 > /dev/null
mount /dev/sda2 /mnt > /dev/null
mkdir /mnt/boot > /dev/null
mount /dev/sda1 /mnt/boot > /dev/null
