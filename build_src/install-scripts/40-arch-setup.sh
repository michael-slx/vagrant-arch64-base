#!/usr/bin/env bash

set -euo pipefail

echo "Installing packages"
SYSTEM="base linux e2fsprogs dosfstools systemd-resolvconf openssh reflector"
GUEST_UTILS="virtualbox-guest-utils-nox"
UCODE="amd-ucode intel-ucode"
UTILS="neovim wget curl sudo man-db man-pages texinfo"
SHELL="zsh grml-zsh-config"
PACKAGES="$SYSTEM $GUEST_UTILS $UCODE $UTILS $SHELL"
pacstrap /mnt $PACKAGES

echo "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab
sed -i -E '/\/boot/ s/(rw,\S*)/\1,noauto,x-systemd.automount/' /mnt/etc/fstab
