#!/usr/bin/env bash

set -euo pipefail

echo 'Setting timezone to UTC'
ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

echo 'Syncing hardware clock'
hwclock --systohc
