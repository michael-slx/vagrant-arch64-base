#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$1"
FILES_DIR="$2"

echo 'Performing package list update'
pacman -Syy --noconfirm
