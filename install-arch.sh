#!/usr/bin/env bash

set -euo pipefail

echo 'Setting NTP and timezone (UTC)'
timedatectl set-ntp true
timedatectl set-timezone Etc/UTC

echo 'Fetching up-to-date mirrorlist & performing system update'
pacman -Syy --noconfirm reflector
reflector --verbose --latest 10 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist.bak
mv /etc/pacman.d/mirrorlist.bak /etc/pacman.d/mirrorlist
pacman -Syy --noconfirm

echo "Partitioning disk"
sfdisk /dev/sda < /tmp/system_files/disk-parts.dump
sync

echo "Creating file systems"
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
sync

echo "Mouting file systems"
swapon /dev/sda3
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

echo "Installing packages"
SYSTEM="base linux e2fsprogs dosfstools systemd-resolvconf openssh reflector"
GUEST_UTILS="virtualbox-guest-utils-nox virtualbox-guest-modules-arch"
UCODE="amd-ucode intel-ucode"
UTILS="vim wget curl man sudo"
SHELL="zsh grml-zsh-config"
PACKAGES="$SYSTEM $GUEST_UTILS $UCODE $UTILS $SHELL"
pacstrap /mnt $PACKAGES

echo "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab
sed -i -E '/\/boot/ s/(rw,\S*)/\1,noauto,x-systemd.automount/' /mnt/etc/fstab

echo "Copying setup files to new system"
mkdir -p /mnt/root/system_files
cp -R /tmp/system_files/* /mnt/root/system_files

echo "Switching into new system"
arch-chroot /mnt /usr/bin/env bash /root/system_files/chroot-exec.sh

echo 'Configuring resolv.conf'
ln -sf "/run/systemd/resolve/stub-resolv.conf" /mnt/etc/resolv.conf

echo 'Finishing installation'
sync
sleep 5
umount -R /mnt
sleep 2
