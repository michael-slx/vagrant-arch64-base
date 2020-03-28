#!/usr/bin/env bash

set -euo pipefail

echo 'Configuring pacman'
sed -i '/^#.*Color /s/^#//' /etc/pacman.conf
sed -i '/^#.*TotalDownload /s/^#//' /etc/pacman.conf
sed -i '/^#.*CheckSpace /s/^#//' /etc/pacman.conf
mkdir -p /etc/pacman.d/hooks
