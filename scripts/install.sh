#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -e

SCRIPT_DIR="$1"
FILES_DIR="$2"

for filename in $SCRIPT_DIR/*-*.sh; do
    "$filename" "$FILES_DIR"
done
