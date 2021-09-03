#!/usr/bin/env bash

set -euo pipefail

echo 'Setting up users'
ZSH_BINARY="$(chsh -l | grep zsh | head -1)"
chsh -s "$ZSH_BINARY"
cp -f /etc/skel/.zshrc /root/.zshrc
useradd -G wheel -m -s "$ZSH_BINARY" vagrant
cat <<eof | chpasswd
root:vagrant
vagrant:vagrant
eof
