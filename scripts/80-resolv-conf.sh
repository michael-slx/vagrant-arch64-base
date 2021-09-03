#!/usr/bin/env bash

set -euo pipefail

echo 'Configuring resolv.conf'
ln -sf "/run/systemd/resolve/stub-resolv.conf" /mnt/etc/resolv.conf
