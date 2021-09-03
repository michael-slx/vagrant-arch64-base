#!/usr/bin/env bash

set -e

SCRIPT_DIR="$1"
FILES_DIR="$2"

echo '[Machine id] Cleaning machine id'
rm -f /mnt/etc/machine-id
