#!/usr/bin/env bash

set -euo pipefail

echo 'Finishing installation'
sync
sleep 5
umount -R /mnt
sleep 2
