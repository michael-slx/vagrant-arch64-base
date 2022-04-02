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

mkdir -p /mnt/root/setup/scripts
cp -R $SCRIPT_DIR/* /mnt/root/setup/scripts

mkdir -p /mnt/root/setup/files
cp -R $FILES_DIR/* /mnt/root/setup/files

arch-chroot /mnt env "FILES_DIR=/root/setup/files" \
                     "SCRIPT_DIR=/root/setup/scripts" \
                     /root/setup/scripts/chroot.sh

ln -sf "/run/systemd/resolve/stub-resolv.conf" /mnt/etc/resolv.conf

efibootmgr \
    --disk /dev/sda --part 1 \
    --create --label "Arch Linux" \
    --loader /vmlinuz-linux \
    --unicode 'root=LABEL=ROOT resume=LABEL=SWAP rootflags=rw,relatime initrd=\initramfs-linux.img add_efi_memmap random.trust_cpu=on rng_core.default_quality=1000 nomodeset nowatchdog mitigations=off quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log_priority=3' \
    --verbose

rm -R /mnt/root/setup
rm -f /mnt/etc/machine-id

sync
umount -R /mnt
swapoff /dev/sda3
