#!/usr/bin/env bash

set -euo pipefail

echo "Partitioning disk"
sfdisk /dev/sda < /tmp/build_files/disk/disk-parts.dump
sync

echo "Creating file systems"
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
sync

echo "Mounting file systems"
swapon /dev/sda3
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
