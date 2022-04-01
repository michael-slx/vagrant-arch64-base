variable "iso_mirror" {
  type = string
}

variable "iso_name" {
  type = string
}

locals {
  scripts_folder_name = "scripts"
  files_folder_name   = "files"
}

locals {
  root_folder =    "${path.root}"
  scripts_folder = "${local.root_folder}/${local.scripts_folder_name}"
  files_folder =   "${local.root_folder}/${local.files_folder_name}"
}

locals {
  remote_dest_folder =  "/tmp"
  scripts_dest_folder = "${local.remote_dest_folder}/${local.scripts_folder_name}"
  files_dest_folder =   "${local.remote_dest_folder}/${local.files_folder_name}"
}

locals {
  iso_ssh_user = "root"
  iso_ssh_password = "root"
}

source "virtualbox-iso" "arch64-base" {
  guest_os_type            = "ArchLinux_64"
  guest_additions_mode     = "disable"
  headless                 = true

  format                   = "ovf"

  http_directory           = "scripts"
  boot_command             = [
    "curl http://{{ .HTTPIP }}:{{ .HTTPPort }}/bootstrap.sh | bash -s -- ${local.iso_ssh_user} ${local.iso_ssh_password}<enter>"
  ]
  boot_keygroup_interval   = "250ms"
  boot_wait                = "75s"

  ssh_username             = "${local.iso_ssh_user}"
  ssh_password             = "${local.iso_ssh_password}"
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
    ["modifyvm", "{{ .Name }}", "--firmware", "efi"],
    ["modifyvm", "{{ .Name }}", "--apic", "on"],
    ["modifyvm", "{{ .Name }}", "--ioapic", "on"],
    ["modifyvm", "{{ .Name }}", "--x2apic", "on"],
    ["modifyvm", "{{ .Name }}", "--biosapic", "apic"],
    ["modifyvm", "{{ .Name }}", "--pae", "on"],
    ["modifyvm", "{{ .Name }}", "--nestedpaging", "on"],
    ["modifyvm", "{{ .Name }}", "--largepages", "on"],
    ["modifyvm", "{{ .Name }}", "--hwvirtex", "on"],
    ["modifyvm", "{{ .Name }}", "--nested-hw-virt", "on"],
    ["modifyvm", "{{ .Name }}", "--paravirtprovider", "default"],
    ["modifyvm", "{{ .Name }}", "--rtcuseutc", "on"],
    ["modifyvm", "{{ .Name }}", "--graphicscontroller", "none"],
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
    sources     = [
      "${local.scripts_folder}",
      "${local.files_folder}"
    ]
    destination = "${local.remote_dest_folder}"
  }

  provisioner "shell" {
    inline = [
      "chmod -R +x ${local.scripts_dest_folder}",
      "${local.scripts_dest_folder}/install.sh ${local.scripts_dest_folder} ${local.files_dest_folder}"
    ]
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    compression_level   = 9
    output              = "dist\\${source.name}_${formatdate("YYYY-MM-DD", timestamp())}.box"
  }
}
