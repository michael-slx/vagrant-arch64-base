#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$1"
FILES_DIR="$2"

echo 'Setting NTP and timezone (UTC)'
timedatectl set-ntp true
timedatectl set-timezone Etc/UTC
