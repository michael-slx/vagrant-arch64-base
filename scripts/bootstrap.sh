#!/usr/bin/env bash
# -*- coding: utf-8 -*-

sed -i '/^#PermitEmptyPasswords/ s/^#//' /etc/ssh/sshd_config
sed -i '/^PermitEmptyPasswords/ s/no/yes/' /etc/ssh/sshd_config
systemctl restart sshd
