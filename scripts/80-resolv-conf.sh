#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$1"
FILES_DIR="$2"

echo 'Configuring resolv.conf'
ln -sf "/run/systemd/resolve/stub-resolv.conf" /mnt/etc/resolv.conf
