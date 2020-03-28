#!/usr/bin/env bash

set -euo pipefail

echo 'Fetching up-to-date mirrorlist & performing system update'
pacman -Syy --noconfirm reflector
reflector --verbose --latest 10 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist.bak
mv /etc/pacman.d/mirrorlist.bak /etc/pacman.d/mirrorlist
pacman -Syy --noconfirm
