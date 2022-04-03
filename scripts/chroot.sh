#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -e

ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime
hwclock --systohc

locale-gen

echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'KEYMAP=us' > /etc/vconsole.conf
echo 'vagrant' > /etc/hostname
echo '127.0.0.1   localhost' >> /etc/hosts
echo '::1         localhost' >> /etc/hosts

cp $FILES_DIR/default-wired.network /etc/systemd/network/20-default-wired.network
systemctl enable systemd-networkd.service systemd-resolved.service

ZSH_BINARY="$(chsh -l | grep zsh | head -1)"

chsh -s "$ZSH_BINARY"
touch /root/.zshrc

useradd -m -s "$ZSH_BINARY" vagrant

cat <<eof | chpasswd
root:vagrant
vagrant:vagrant
eof

git clone https://github.com/ohmyzsh/ohmyzsh.git /home/vagrant/.oh-my-zsh
chown -R vagrant:vagrant /home/vagrant/.oh-my-zsh
cp $FILES_DIR/zshrc /home/vagrant/.zshrc

sed -i '/^#.*CheckSpace/s/^#//' /etc/pacman.conf
sed -i '/^#.*Color/s/^#//' /etc/pacman.conf
sed -i '/^#.*VerbosePkgLists/s/^#//' /etc/pacman.conf

sed -i '/^#NoExtract/s/^#//' /etc/pacman.conf
sed -i '/^NoExtract /s/$/ pacman-mirrorlist/' /etc/pacman.conf

systemctl enable vboxservice.service
systemctl mask modprobe@drm
systemctl mask systemd-remount-fs.service

cp $FILES_DIR/vimrc.vim /root/.vimrc
cp $FILES_DIR/vimrc.vim /home/vagrant/.vimrc

cp $FILES_DIR/reflector.conf /etc/xdg/reflector/reflector.conf
cp $FILES_DIR/reflector-firstboot.service /usr/lib/systemd/system/reflector-firstboot.service
systemctl enable reflector.timer reflector-firstboot.service

cp $FILES_DIR/mkinitcpio.conf /etc/mkinitcpio.conf
cp $FILES_DIR/mkinitcpio-linux.preset /etc/mkinitcpio.d/linux.preset
mkinitcpio -P linux

mkdir -p /home/vagrant/.ssh
cat $FILES_DIR/vagrant.pub >> /home/vagrant/.ssh/authorized_keys
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
systemctl enable sshd

cp -f $FILES_DIR/sudoers /etc/sudoers
chmod 440 /etc/sudoers

UNUSED_PKGS=$(pacman -Qdtq || true)
if [[ ! -z "$UNUSED_PKGS" ]]; then
  pacman -Rs --noconfirm $UNUSED_PKGS || true
fi

# Dangerous
yes | pacman -Scc || true
