#!/usr/bin/env bash

set -euo pipefail

echo 'Setting up locale'
sed -i '/^#.*en_US\.UTF\-8 UTF\-8/s/^#//' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'KEYMAP=us' > /etc/vconsole.conf
