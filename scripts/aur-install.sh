#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -e

git clone https://aur.archlinux.org/yay.git $HOME/yay
cd $HOME/yay
makepkg -fsri --noconfirm

cd $HOME
rm -Rf $HOME/yay

yay -S --noconfirm pikaur pacaur yay
# Dangerous
yes | yay -Scc
