#!/usr/bin/env bash

sed -i '/^#PermitEmptyPasswords/ s/^#//' /etc/ssh/sshd_config
sed -i '/^PermitEmptyPasswords/ s/no/yes/' /etc/ssh/sshd_config
systemctl enable --now sshd dhcpcd
