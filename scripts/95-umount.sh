#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$1"
FILES_DIR="$2"

echo 'Finishing installation'
sync
sleep 5
umount -R /mnt
sleep 2
