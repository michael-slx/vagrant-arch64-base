#!/usr/bin/env bash

set -eo pipefail

ISO_MIRROR="https://geo.mirror.pkgbuild.com"
ISO_NAME="$(curl -fs "${ISO_MIRROR}/iso/latest/" | grep -Eo 'archlinux-[0-9]{4}\.[0-9]{2}\.[0-9]{2}-x86_64.iso' | head -n 1)"
BOX_NAME="arch64-base_$(git describe)"

echo "Mirror: $ISO_MIRROR"
echo "ISO Name: $ISO_NAME"
echo "Box Name: $BOX_NAME"

packer build \
  -var "iso_mirror=${ISO_MIRROR}" \
  -var "iso_name=${ISO_NAME}" \
  -var "output_file=$BOX_NAME" \
  arch64-base.pkr.hcl

cd dist
b2sum $BOX_NAME.box > $BOX_NAME.b2sums.txt
md5sum $BOX_NAME.box > $BOX_NAME.md5sums.txt
sha1sum $BOX_NAME.box > $BOX_NAME.sha1sums.txt
sha256sum $BOX_NAME.box > $BOX_NAME.sha256sums.txt
sha512sum $BOX_NAME.box > $BOX_NAME.sha512sums.txt
cd ..
