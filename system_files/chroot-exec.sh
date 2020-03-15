#!/usr/bin/env bash

set -euo pipefail

echo 'Setting timezone to UTC'
ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

echo 'Syncing hardware clock'
hwclock --systohc

echo 'Setting up locale'
sed -i '/^#.*en_US\.UTF\-8 UTF\-8 /s/^#//' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'KEYMAP=us' > /etc/vconsole.conf

echo 'Configuring hostname and hosts file'
echo 'vagrant' > /etc/hostname
echo '127.0.0.1   localhost' > /etc/hosts
echo '::1		      localhost' > /etc/hosts

echo 'Configuring network'
cp -f /root/system_files/networkd/** /etc/systemd/network/
systemctl enable systemd-networkd.service systemd-resolved.service

echo 'Configuring pacman'
sed -i '/^#.*Color /s/^#//' /etc/pacman.conf
sed -i '/^#.*TotalDownload /s/^#//' /etc/pacman.conf
sed -i '/^#.*CheckSpace /s/^#//' /etc/pacman.conf
mkdir -p /etc/pacman.d/hooks

echo 'Setting up InitRamFS'
cp -fR /root/system_files/initramfs/** /etc/
chmod -R 644 /etc/mkinitcpio*
chmod 755 /etc/mkinitcpio.d
mkinitcpio -P

echo 'Setting up reflector'
cp -R /root/system_files/auto-reflector /usr/share/
chmod 555 /usr/share/auto-reflector
chmod 440 /usr/share/auto-reflector/*
chmod 555 /usr/share/auto-reflector/auto-reflector.sh
ln -sf /usr/share/auto-reflector/mirrorupgrade.hook /etc/pacman.d/hooks/50-mirrorupgrade.hook
ln -sf /usr/share/auto-reflector/reflector.service /usr/lib/systemd/system/reflector.service
ln -sf /usr/share/auto-reflector/reflector.timer /usr/lib/systemd/system/reflector.timer
ln -sf /usr/share/auto-reflector/auto-reflector.sh /usr/sbin/auto-reflector
systemctl enable reflector.timer
auto-reflector
pacman -Syyuu --noconfirm

echo 'Installing boot loader'
bootctl --path=/boot install

cp -fR /root/system_files/pacman-hooks/systemd-boot.hook /etc/pacman.d/hooks/100-systemd-boot.hook
cp -R /root/system_files/loader/** /boot/loader

ROOT_FS_UUID="$(blkid -s UUID -o value /dev/sda2)"
echo "Setting RootFS UUID: $ROOT_FS_UUID"
sed -i "s|FSUUID|$ROOT_FS_UUID|g" /boot/loader/entries/arch.conf
sed -i "s|FSUUID|$ROOT_FS_UUID|g" /boot/loader/entries/arch-fallback.conf

echo 'Configuring SSH'
cp -fR /root/system_files/ssh/sshd_config /etc/ssh/sshd_config
chmod 640 /etc/ssh/sshd_config
systemctl enable sshd

echo 'Configuring sudo'
cp -fR /root/system_files/sudo/sudoers /etc/sudoers
chmod 440 /etc/sudoers

echo 'Setting up users'
ZSH_BINARY="$(chsh -l | grep zsh | head -1)"
chsh -s "$ZSH_BINARY"
cp -f /etc/skel/.zshrc /root/.zshrc
useradd -G wheel -m -s "$ZSH_BINARY" vagrant
cat <<eof | chpasswd
root:vagrant
vagrant:vagrant
eof

echo 'Setting up public SSH key'
mkdir -p /home/vagrant/.ssh
cat /root/system_files/ssh/vagrant.pub >> /home/vagrant/.ssh/authorized_keys
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "Configuring vim"
echo '' >> /etc/vimrc
echo '' >> /etc/vimrc
echo 'colorscheme evening' >> /etc/vimrc
echo '' >> /etc/vimrc

echo 'Configuring profile defaults'
cp /root/system_files/profile/defaults.sh /etc/profile.d/defaults.sh

echo 'Starting VM guest modules'
systemctl enable vboxservice.service

echo 'Masking unneeded services'
systemctl mask modprobe@drm
systemctl mask systemd-remount-fs.service

echo 'Deleting setup files'
rm -fR /root/system_files

echo 'Cleaning orphaned packages'
UNUSED_PKGS=$(pacman -Qdtq || true)
if [[ ! -z "$UNUSED_PKGS" ]]; then
  echo 'Cleaning ...'
  pacman -Rs --noconfirm $UNUSED_PKGS || true
fi

echo 'Cleaning package cache'
# Dangerous
yes | pacman -Scc || true
