variable "iso_mirror" {
  type = string
}

variable "iso_name" {
  type = string
}

variable "output_file" {
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
  guest_os_type = "ArchLinux_64"
  headless      = true

  cpus           = 2
  memory         = 2048
  firmware       = "efi"
  rtc_time_base  = "UTC"
  nested_virt    = true
  gfx_controller = "none"

  http_directory           = "scripts"
  boot_command             = [
    "curl http://{{ .HTTPIP }}:{{ .HTTPPort }}/bootstrap.sh | bash -s -- ${local.iso_ssh_user} ${local.iso_ssh_password}<enter>"
  ]
  boot_keygroup_interval   = "250ms"
  boot_wait                = "2m"

  ssh_username     = "${local.iso_ssh_user}"
  ssh_password     = "${local.iso_ssh_password}"
  ssh_wait_timeout = "30s"
  shutdown_command = "sudo shutdown -P now 'Vagrant is shutting down this VM'"

  disk_size                = 65536
  hard_drive_interface     = "sata"
  hard_drive_nonrotational = true
  hard_drive_discard       = true

  iso_url       = "${var.iso_mirror}/iso/latest/${var.iso_name}"
  iso_checksum  = "file:${var.iso_mirror}/iso/latest/sha256sums.txt"
  iso_interface = "sata"

  guest_additions_mode = "disable"

  vboxmanage = [
    # misc VM options
    ["modifyvm", "{{ .Name }}", "--firmware", "efi64"],
    ["modifyvm", "{{ .Name }}", "--biosbootmenu", "disabled"],

    # boot order for installation
    ["modifyvm", "{{ .Name }}", "--boot1", "dvd"],
    ["modifyvm", "{{ .Name }}", "--boot2", "disk"],
    ["modifyvm", "{{ .Name }}", "--boot3", "none"],
    ["modifyvm", "{{ .Name }}", "--boot4", "none"],
  ]

  vboxmanage_post = [
    # boot order
    ["modifyvm", "{{ .Name }}", "--boot1", "disk"],
    ["modifyvm", "{{ .Name }}", "--boot2", "none"],
    ["modifyvm", "{{ .Name }}", "--boot3", "none"],
    ["modifyvm", "{{ .Name }}", "--boot4", "none"],
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
    output              = "dist\\${var.output_file}.box"
  }
}
