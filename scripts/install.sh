#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -e

export SCRIPT_DIR="$1"
export FILES_DIR="$2"

PACKAGES=(
    base
    base-devel
    linux
    e2fsprogs dosfstools systemd-resolvconf openssh reflector
    virtualbox-guest-utils-nox
    vim nano wget curl sudo git man-db man-pages texinfo
    zsh
)



timedatectl set-ntp true
timedatectl set-timezone Etc/UTC

sfdisk /dev/sda < $FILES_DIR/disk-parts.dump
sync

mkfs.fat -F32 -n "EFI" /dev/sda1
mkfs.ext4 -L "ROOT" /dev/sda2
mkswap -L "SWAP" /dev/sda3
sync

swapon /dev/sda3
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

pacstrap /mnt ${PACKAGES[@]}

genfstab -L /mnt >> /mnt/etc/fstab
sed -i -E '/\/boot/ s/(rw,\S*)/\1,noauto,x-systemd.automount/' /mnt/etc/fstab

mkdir -p /mnt/setup/scripts
cp -R $SCRIPT_DIR/* /mnt/setup/scripts
chmod -R +x /mnt/setup

mkdir -p /mnt/setup/files
cp -R $FILES_DIR/* /mnt/setup/files

arch-chroot /mnt env "FILES_DIR=/setup/files" \
                     "SCRIPT_DIR=/setup/scripts" \
                     /setup/scripts/chroot.sh
arch-chroot /mnt su - vagrant /setup/scripts/aur-install.sh

ln -sf "/run/systemd/resolve/stub-resolv.conf" /mnt/etc/resolv.conf

rm -R /mnt/setup
rm -f /mnt/etc/machine-id

sync
umount -R /mnt
swapoff /dev/sda3
