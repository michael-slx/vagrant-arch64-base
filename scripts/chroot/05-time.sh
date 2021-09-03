#!/usr/bin/env bash

set -euo pipefail

echo '[CHROOT][Time] Setting timezone to UTC'
ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

echo '[CHROOT][Time] Syncing hardware clock'
hwclock --systohc
