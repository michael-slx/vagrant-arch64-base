variable "iso_mirror" {
  type    = string
  default = ""
}

variable "iso_name" {
  type    = string
  default = ""
}

source "virtualbox-iso" "arch64-base" {
  guest_os_type            = "ArchLinux_64"
  guest_additions_mode     = "disable"
  headless                 = true

  format                   = "ovf"

  http_directory           = "build_src"

  boot_command             = [
    "curl http://{{ .HTTPIP }}:{{ .HTTPPort }}/00-bootstrap-ssh.sh | bash<enter>"
  ]
  boot_keygroup_interval   = "1s"
  boot_wait                = "2m"

  ssh_username             = "root"
  ssh_password             = ""
  ssh_wait_timeout         = "30s"
  shutdown_command         = "sudo shutdown -P now 'Vagrant is shutting down this VM'"

  disk_size                = 65536
  hard_drive_interface     = "sata"
  hard_drive_nonrotational = true
  hard_drive_discard       = true

  iso_url                  = "${var.iso_mirror}/iso/latest/${var.iso_name}"
  iso_checksum             = "file:${var.iso_mirror}/iso/latest/sha1sums.txt"
  iso_interface            = "sata"

  vboxmanage               = [
    # misc VM options
    ["modifyvm", "{{ .Name }}", "--firmware", "efi64"],
    ["modifyvm", "{{ .Name }}", "--ioapic", "on"],
    ["modifyvm", "{{ .Name }}", "--pae", "on"],
    ["modifyvm", "{{ .Name }}", "--hwvirtex", "on"],
    ["modifyvm", "{{ .Name }}", "--nested-hw-virt", "on"],
    ["modifyvm", "{{ .Name }}", "--hpet", "on"],
    ["modifyvm", "{{ .Name }}", "--rtcuseutc", "on"],
    ["modifyvm", "{{ .Name }}", "--graphicscontroller", "vmsvga"],
    ["modifyvm", "{{ .Name }}", "--biosbootmenu", "disabled"],

    # boot order
    ["modifyvm", "{{ .Name }}", "--boot1", "dvd"],
    ["modifyvm", "{{ .Name }}", "--boot2", "disk"],
    ["modifyvm", "{{ .Name }}", "--boot3", "none"],
    ["modifyvm", "{{ .Name }}", "--boot4", "none"],

    # more CPUs and RAM for faster building (we'll reduce this later)
    ["modifyvm", "{{ .Name }}", "--cpus", "8"],
    ["modifyvm", "{{ .Name }}", "--memory", "8192"]
  ]
  vboxmanage_post          = [
    # reduce CPUs and RAM for distribution
    ["modifyvm", "{{ .Name }}", "--cpus", "1"],
    ["modifyvm", "{{ .Name }}", "--memory", "1024"]
  ]
}

build {
  sources = ["source.virtualbox-iso.arch64-base"]

  provisioner "file" {
    destination = "/tmp"
    source      = "build_files"
  }

  provisioner "file" {
    destination = "/tmp"
    source      = "build_src/install-scripts"
  }

  provisioner "shell" {
    inline = [
      "chmod -R +x /tmp/install-scripts",
      "/tmp/install-scripts/10-time.sh",
      "/tmp/install-scripts/20-pacman.sh",
      "/tmp/install-scripts/30-disk.sh",
      "/tmp/install-scripts/40-arch-setup.sh",
      "/tmp/install-scripts/50-chroot.sh /tmp/build_files",
      "/tmp/install-scripts/80-resolv-conf.sh",
      "/tmp/install-scripts/90-clean-machine-id.sh",
      "/tmp/install-scripts/95-umount.sh"
    ]
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    compression_level   = 9
    output              = "dist\\${source.name}_${formatdate("YYYY-MM-DD", timestamp())}.box"
  }
}
