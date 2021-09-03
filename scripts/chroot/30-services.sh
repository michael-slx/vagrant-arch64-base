#!/usr/bin/env bash

set -euo pipefail

echo '[CHROOT][Services] Starting VM guest modules'
systemctl enable vboxservice.service

echo '[CHROOT][Services] Masking unneeded services'
systemctl mask modprobe@drm
systemctl mask systemd-remount-fs.service
