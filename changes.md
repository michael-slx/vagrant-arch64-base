# Change log

## `20200315`

- Initial release

## `20200316`

- Switched to using the official installation ISO disk image. This is supported using a boot command to enable SSH.
- This is the first version that can be built from this repo. Earlier commits in this project don't contain the required customized ISO image.

## `20200328`

- Added `irqbalance`
- Disabled CPU exploit mitigations
- Disabled kernel watchdogs
- Split apart and refactored scripts

## `20200529`

- Removed obsolete `virtualbox-guest-modules-arch` package

## `20200708`

- Fix `iso_checksum` syntax error
- Update Arch ISO disk to `2020.07.01`

## `20200709`

- Fix issues regarding multi-core CPUs

## `20200807`

- Update Arch ISO disk to `2020.08.01`

`20200821`

- Update to work with new reflector version

## `20200904`

- Update Arch ISO disk to `2020.09.01`
- Update and clean up config files
- Remove `irqbalance`: When a VM does not use host resources directly, `irqbalance` isn't needed for VMs.
- Remove `man`

## `20201003`

- Update Arch ISO disk to `2020.10.01`
- Extend boot timeout to 1 minute. (Boot commands were typed too early.)
- Boot command with HTTP server URL didn't work anymore due to `zsh` treating the colon differently now.

## `20201101`

- Update Arch ISO disk to `2020.11.01`
- Switch to `mirror.rackspace.com` for ISO download. Official Arch archive only contains new ISOs after a few days.
- Extend boot timeout to 2 minutes. (Boot commands were typed too early.)

## `20201204`

- Update Arch ISO disk to `2020.12.01`
- Switch to neovim
  Use `nvim` instead of `vim` to edit files
- Include `man` & `info`
- Let zsh source global `/etc/profile`
- Let reflector pick 50 mirrors instead of 25
- Globally set XDG base directory variables
- Disable 3D acceleration (Not needed for a CLI box)

## `20210101`

- Update Arch ISO disk to `2021.01.01`

## `20210201`

- Update Arch ISO disk to `2021.02.01`
- Change SSH bootstrap script to restart services instead of just starting them. New version of Arch ISO starts SSH server on boot.

## `20210301`

- Update Arch ISO disk to `2021.03.01`
- Switch to a more traditional neovim config: Specifically, line numbers and the line cursor are now disabled.
- Change SSH bootstrap script to completely avoid dhcpcd as new ISOs use systemd-resolved instead.
- Replace UUIDs with filesystem labels for bootloader config
- Make initramfs even smaller

## `20210402`

- **Build system**:
  The build process now automatically looks for the newest Arch installer ISO. This is done using a wrapper shell script, therefore a working Bash interpreter is required as well as `curl`, `grep` and `head`.
- Completely drop fallback initramfs
  Fallback initramfs isn't needed for a Vagrant-style "throwaway VM".
- Enable network options `UseDomains` and `UseNTP`.

## `20210501`

- Drop processor ucode updates as they aren't needed for VMs
- Add script for deleting machine id after installation. Systemd will automatically generate one on first boot.
- Run Reflector on first boot
- Fully disable IPv6

## `20210602`

- Remove mirrorlist upgrade pacman hook
  It doesn't make sense to run Reflector on the old mirrorlist, then deleting the new one. Also it is quite a time hog when running updates.

## `20210801`

- Fix editing of pacman and locale config

## `20210903`

- Switch Packer to HCL-based configuration
- Miscellaneous improvements for build system

## `20211101`

- Reduce mirrorlist to 10 mirrors
- Update sshd config
- Update general VM options

## `20220515`

- Major refactor of build system
- Switch from `neovim` to `vim`
- Add `nano`
- Use `oh-my-zsh` ZSH config
- Add `base-devel` packages
- Add `pikaur`, `pacaur` and `yay` AUR helpers

## `20220702`

- **Fix line endings**

  Config files should use LF-only line endings.

## `20220824`

- Turn off ZSH completion progress dots
- Enable generation of `en_US.UTF-8` locale

## `20220904`

- Switch ISO mirror to https://geo.mirror.pkgbuild.com

## `20221001`

- Add checksum calculation to build
- Switch to sha256sums for ISO download
