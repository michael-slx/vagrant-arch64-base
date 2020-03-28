#!/usr/bin/env bash

set -euo pipefail

echo 'Setting NTP and timezone (UTC)'
timedatectl set-ntp true
timedatectl set-timezone Etc/UTC
