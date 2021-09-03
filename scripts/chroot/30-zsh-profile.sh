#!/usr/bin/env bash

set -e

echo "[CHROOT][zsh] Configuring zsh to load /etc/profile"
echo -n "emulate sh -c 'source /etc/profile'" >> /etc/zsh/zprofile
