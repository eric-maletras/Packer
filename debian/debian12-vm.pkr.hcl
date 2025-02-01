# Variables pour personnaliser le déploiement
variable "esxi_host" {
  default = "192.168.62.100"
}

variable "esxi_user" {
  default = "root"
}

variable "esxi_password" {
  default = "Btssio75000!"
}

variable "datastore" {
  default = "datastore1"
}

variable "iso_path" {
  default = "[datastore1] ISOs/debian-12.2.0-amd64-DVD-1.iso"
}

variable "vm_name" {
  default = "M2L-LSRV05"
}

variable "network_name" {
  default = "VM Network"
}

variable "network_name2" {
  default = "VLAN"
}


variable "root_password" {
  default = "Btssio75000"
}

variable "user_name" {
  default = "admin1"
}

variable "user_password" {
  default = "Btssio75000"
}

source "vsphere-iso" "debian_12" {
  # Connexion à l'hôte ESXi
  host                = var.esxi_host
  vcenter_server      = var.esxi_host
  username            = var.esxi_user
  password            = var.esxi_password
  insecure_connection = true
  datastore           = var.datastore

  # ISO à utiliser pour l'installation
  iso_paths    = [var.iso_path]
  iso_checksum = "none" # Pas de vérification de checksum pour simplifier

  # Configuration matérielle de la VM
  vm_name              = var.vm_name
  guest_os_type        = "debian10_64Guest" # Type d'OS pour ESXi
  CPUs                 = 2
  RAM                  = 2048
  disk_controller_type = ["pvscsi"] # Paravirtual SCSI pour de meilleures performances

  # Configuration du stockage
  storage {
    disk_size             = 61440 # Taille du disque en Mo (60 Go)
    disk_thin_provisioned = true  # Activation du thin provisioning
  }

  # Configuration réseau
  network_adapters {
    network      = var.network_name
    network_card = "e1000"
  }

  network_adapters {
    network      = var.network_name2
    network_card = "e1000"
  }


  #  boot_wait = "20s"
  #  floppy_files = ["./preseed.cfg"]

  http_directory = "./"

  boot_command = [
    "<esc><wait>",
    "install ",
    "auto=true ",
    "priority=critical ",
    "interface=ens32 ",
    "locale=fr_FR.UTF-8 ",
    "keyboard-configuration/layoutcode=fr ",
    "keyboard-configuration/variantcode=oss ",
    "keyboard-configuration/modelcode=pc105 ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "root_password=${var.root_password}",
    " user_name=${var.user_name}",
    " user_password=${var.user_password}",
    "<enter>"
  ]


  # Communicateur désactivé pour le moment
  communicator = "none"

  shutdown_timeout = "15m"
  shutdown_command = "echo 'Rebooting...' && reboot"
  #  skip_export       = false

  # Garder la VM enregistrée
  #  exported = false
}


build {
  sources = ["source.vsphere-iso.debian_12"]

  #  http_directory = "http"

  provisioner "shell" {
    inline = [
      "echo 'Provisioning complete!'",
      "sleep 2",
      "echo 'Rebooting now...' && reboot"
    ]
  }
}

