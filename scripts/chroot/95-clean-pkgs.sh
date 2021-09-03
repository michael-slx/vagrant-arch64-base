#!/usr/bin/env bash

set -euo pipefail

echo 'Cleaning orphaned packages'
UNUSED_PKGS=$(pacman -Qdtq || true)
if [[ ! -z "$UNUSED_PKGS" ]]; then
  echo 'Cleaning ...'
  pacman -Rs --noconfirm $UNUSED_PKGS || true
fi

echo 'Cleaning package cache'
# Dangerous
yes | pacman -Scc || true
