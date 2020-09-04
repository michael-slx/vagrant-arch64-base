#!/usr/bin/env bash

set -euo pipefail

echo 'Performing package list update'
pacman -Syy --noconfirm
