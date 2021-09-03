#!/usr/bin/env bash

set -euo pipefail

echo '[CHROOT][Cleanup] Cleaning orphaned packages'
UNUSED_PKGS=$(pacman -Qdtq || true)
if [[ ! -z "$UNUSED_PKGS" ]]; then
  echo 'Cleaning ...'
  pacman -Rs --noconfirm $UNUSED_PKGS || true
fi

echo '[CHROOT][Cleanup] Cleaning package cache'
# Dangerous
yes | pacman -Scc || true
