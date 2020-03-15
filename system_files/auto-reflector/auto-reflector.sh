#!/bin/env bash

error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo ":: ERROR :: Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo ":: ERROR :: Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  exit "${code}"
}
trap 'error ${LINENO}' ERR

if [[ $EUID -ne 0 ]]; then
   echo ":: ERROR :: This script must be run as root"
   exit 1
fi

echo ":: REFLECTOR :: Starting update of mirror list"

reflector --latest 25 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist.new
mv /etc/pacman.d/mirrorlist.new /etc/pacman.d/mirrorlist

echo ":: REFLECTOR :: Finished!"
