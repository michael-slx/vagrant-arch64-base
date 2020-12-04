#!/usr/bin/env bash

set -e

echo "Configuring zsh to load /etc/profile"
echo -n "emulate sh -c 'source /etc/profile'" >> /etc/zsh/zprofile
