#!/usr/bin/env bash

set -eo pipefail

ISO_MIRROR="https://mirror.pkgbuild.com"
ISO_NAME="$(curl -fs "${ISO_MIRROR}/iso/latest/" | grep -Eo 'archlinux-[0-9]{4}\.[0-9]{2}\.[0-9]{2}-x86_64.iso' | head -n 1)"

echo "Mirror: $ISO_MIRROR"
echo "ISO Name: $ISO_NAME"

packer build \
  -var "iso_mirror=${ISO_MIRROR}" \
  -var "iso_name=${ISO_NAME}" \
  arch64-base.pkr.hcl
