#!/usr/bin/env bash

set -euo pipefail

echo '[CHROOT][Locale] Setting up locale'
sed -i '/^#.*en_US\.UTF\-8 UTF\-8/s/^#//' /etc/locale.gen
locale-gen > /dev/null
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'KEYMAP=us' > /etc/vconsole.conf
