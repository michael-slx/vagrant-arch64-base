# Arch Linux base box

> A minimalistic Arch Linux-based Vagrant box

<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Using this box](#using-this-box)
- [Building](#building)
- [Pre-installed packages](#pre-installed-packages)
- [Partitioning](#partitioning)
- [System configuration](#system-configuration)
- [Security](#security)
- [Contributions](#contributions)
- [Legal](#legal)

<!-- /TOC -->

This project contains the build system and configuration files for the virtualized system. The Arch Linux box is suitable for anyone looking to build a lean, fast-booting development environment bottom-up.

**Do not** use this box as a basis for production systems - not even deployment testbeds - as long as you are not extremely certain of what you are doing. Please see the [**Security** section](#security) for the inherent security tradeoffs.

## Using this box

If you haven't previously used **Vagrant**, please consult [**Vagrant's introductory Guide**](https://www.vagrantup.com/intro/index.html).

To quickly **get started** with this box, type:

```shell
$ vagrant init michael-slx/arch64-base
$ vagrant up
```

*Happy customizing! ;-}*

## Building

This project uses [**Packer**](https://packer.io/) as the build system, so make sure you have that installed as well as a recent version of [VirtualBox](https://www.virtualbox.org/).

To build a working Vagrant box execute the following command in the top-level directory:

```shell
$ bash ./build.sh
```

The final file will be placed in the `dist/` directory.

## Pre-installed packages

- [`base` package set](https://www.archlinux.org/packages/core/any/base/)
- `linux` _(of course - what did you expect?)_
- User utilities: `neovim`, `wget`, `curl`, `sudo`, `man`, `info`
- Shell: `zsh`, `grml-zsh-config`
- File systems: `e2fsprogs` and `dosfstools`
- SSH server: `openssh`
- `systemd-resolvconf` (compatibility layer for `systemd-resolved` DNS resolver)
- `reflector` (sorts pacman's mirror list)
- VirtualBox guest utilities (`virtualbox-guest-utils-nox`)

## Partitioning

The system's virtual hard disk is partitioned as follows (using GPT):

Device    | File system | Size    | Usage
----------|-------------|---------|-------------------------------
/dev/sda1 | vFAT        | 512 MB  | `/boot` (EFI system partition)
/dev/sda2 | ext4        | 59.5 GB | `/` (Root file system)
/dev/sda3 | _(Swap)_    | 4 GB    | Swap memory partition

## System configuration

The following additional configuration is applied by default:

- Time: Default Arch NTP servers, UTC time zone
- Networking:
  -  `systemd-networkd` network manager
  - `systemd-resolved` DNS resolver
  - `systemd-resolvconf` compatibility layer
  - DHCP configuration for IPv4 wired networks
  - Default hostname: `vagrant`
- `en_US.UTF-8` locale, `us` keymap
- Automatic (delayed) mounting of EFI system partition
- Immediate RW mounting of root partition (`systemd-remount-fs.service` masked)
- InitRamFs uses `systemd` and is optimized for fast booting
- `systemd-boot` bootloader
- Silent booting using kernel command line options
- Hardware and processor entropy generation is trusted using kernel command line options
- CPU exploit mitigations are disabled
- Watchdogs are disabled
- KMS and DRM disabled
- reflector sorts pacman mirror list by download speed. Only HTTPS mirrors are used. reflector is executed automatically on a weekly timer and on first boot.
- Machine ID generated on first boot
- Fancy output for pacman
- AUR helpers: `pikaur`, `pacaur`, `yay`
- less as default pager, vim as editor (`EDITOR`, `VISUAL`)
- User setup:
  - `vagrant` user
  - `vagrant` as a password for the root and vagrant users
  - zsh as default shell for `vagrant `user, includes `oh-my-zsh`
  - Password-less sudo for `vagrant `user
- SSH
  - Root login using password allowed
  - Vagrant insecure keypair authentication for `vagrant` user

## Security

As stated above this Vagrant comes with some inherent security risks, making it unsuitable as a basis for production environments or even production testbeds. Most of these security risks are inherent to this system being a development environment optimized for simplicity, flexibility and speed.

The following is a non-exhaustive list of security loopholes. The above warning however still applies, use a real production environment instead.

- CPU exploit mitigations disabled
- Trusting of hardware RNGs
- Insecure SSH configuration
- Insecure user/password setup, sudo
- No network security (firewall)
- Very dynamic network configuration
- No kernel-level security setup (SELinux, etc.)
- VirtualBox guest utilities may potentially pose a security risk

## Contributions

Participants and contributors are welcome! :-) You are invited to submit issues as well as pull requests should an update break anything or if you think something important is missing.

Please foresee from submitting issues in the following cases:

- Packages are outdated in the public box file (unless a package is extremely old or no longer maintained)
- Adding extra servers, network or security software, remote access tools, provisioning tools, etc.
- Changing a fundamental design decision such as choice of packages, partitioning, boot loader, initrd, etc. unless the current solution is broken, outdated or very slow.

_- Thank you_


## Legal

This project's configuration files and installation scripts are licensed under the [**Apache License, Version 2**](license.txt).

This project is **not** an official project of the Arch Linux distribution. The Arch Linux name and logo are recognized trademarks. Some rights reserved.
