#!/usr/bin/env bash

set -euo pipefail

echo 'Starting VM guest modules'
systemctl enable vboxservice.service

echo 'Masking unneeded services'
systemctl mask modprobe@drm
systemctl mask systemd-remount-fs.service
