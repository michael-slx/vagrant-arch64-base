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
- [Change log](#change-log)
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
$ packer build arch64-base.json
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
- Processor microcode updates: `amd-ucode`, `intel-ucode`

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
- `systemd-boot` as bootloader
  - Loader menu timeout disabled
  - Automatic updating using pacman hook.
- Silent booting using kernel command line options
- Hardware and processor entropy generation is trusted using kernel command line options
- CPU exploit mitigations are disabled
- Watchdogs are disabled
- KMS and DRM disabled
- reflector sorts pacman mirror list by download speed. Only HTTPS mirrors are used. reflector is executed automatically on mirror list update (pacman hook) and a weekly timer.
- Fancy output for pacman
- less as default pager, neovim as editor (`EDITOR`, `VISUAL`)
- User setup:
  - `vagrant ` user
  - `vagrant` as a password for the root and vagrant users
  - zsh as default shell for both users
  - Password-less sudo for `vagrant `user
- SSH
  - IPv4 only
  - Root login using password allowed
  - Reverse DNS disabled
  - Keep-alive enabled
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

## Change log

- `20200315`: Initial release
- `20200316`:
  - Switched to using the official installation ISO disk image. This is supported using a boot command to enable SSH.
  - This is the first version that can be built from this repo. Earlier commits in this project don't contain the required customized ISO image.
- `20200328`:
  - Added `irqbalance`
  - Disabled CPU exploit mitigations
  - Disabled kernel watchdogs
  - Split apart and refactored scripts
- `20200529`:
  - Removed obsolete `virtualbox-guest-modules-arch` package
- `20200708`:
  - Fix `iso_checksum` syntax error
  - Update Arch ISO disk to `2020.07.01`
- `20200709`:
  - Fix issues regarding multi-core CPUs
- `20200807`:
  - Update Arch ISO disk to `2020.08.01`
- `20200821`:
  - Update to work with new reflector version
- `20200904`:
  - Update Arch ISO disk to `2020.09.01`
  - Update and clean up config files
  - Remove `irqbalance`: When a VM does not use host resources directly, `irqbalance` isn't needed for VMs.
  - Remove `man`
- `20201003`:
  - Update Arch ISO disk to `2020.10.01`
  - Extend boot timeout to 1 minute. (Boot commands were typed too early.)
  - Boot command with HTTP server URL didn't work anymore due to `zsh` treating the colon differently now.
- `20201101`:
  - Update Arch ISO disk to `2020.11.01`
  - Switch to `mirror.rackspace.com` for ISO download. Official Arch archive only contains new ISOs after a few days.
  - Extend boot timeout to 2 minutes. (Boot commands were typed too early.)
- `20201204`:
  - Update Arch ISO disk to `2020.12.01`
  - Switch to neovim
    Use `nvim` instead of `vim` to edit files
  - Include `man` & `info`
  - Let zsh source global `/etc/profile`
  - Let reflector pick 50 mirrors instead of 25
  - Globally set XDG base directory variables
  - Disable 3D acceleration (Not needed for a CLI box)
- `20210101`:
  - Update Arch ISO disk to `2021.01.01`
- `20210201`:
  - Update Arch ISO disk to `2021.02.01`
  - Change SSH bootstrap script to restart services instead of just starting them. New version of Arch ISO starts SSH server on boot.
- `20210301`:
  - Update Arch ISO disk to `2021.03.01`
  - Switch to a more traditional neovim config: Specifically, line numbers and the line cursor are now disabled.
  - Change SSH bootstrap script to completely avoid dhcpcd as new ISOs use systemd-resolved instead.
  - Replace UUIDs with filesystem labels for bootloader config
  - Make initramfs even smaller


## Legal

This project's configuration files and installation scripts are licensed under the [**Apache License, Version 2**](http://www.apache.org/licenses/LICENSE-2.0).

```
Copyright 2020-2021 Michael Schantl

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

This project is **not** an official project of the Arch Linux distribution. The Arch Linux name and logo are recognized trademarks. Some rights reserved.
