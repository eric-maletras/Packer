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

variable ssh_username {
  type = string
  default = "admin1"
}

variable ssh_password {
  type = string
  default = "Btssio75000"
}


variable "vm_name" {
 type = string
}

variable "vm_hostname" {
  type = string
}

variable "vm_domain" {
  type = string
}


variable "guest_os_type" {
  type = string
  default = "debian10_64Guest"
}

variable "network_name" {
  type = string
#  default = "VM Network"
}

variable "network_name2" {
  type = string
#  default = "VLAN"
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
  guest_os_type        = var.guest_os_type
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
    "netcfg/get_hostname=${var.vm_hostname} netcfg/get_domain=${var.vm_domain} ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg",
    "<enter>"
  ]


  # Configuration SSH pour que Packer puisse se connecter après l'installation
  communicator = "ssh"

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = "15m"

  ip_wait_timeout = "25m"
 

  # Configuration du snapshot après la création
  create_snapshot  = true
  snapshot_name    = "InitSnapshot"

  shutdown_timeout = "15m"

}


build {
  sources = ["source.vsphere-iso.debian_12"]

  provisioner "shell" {
    inline = [
      "echo 'Configuration de ens32 en IP statique...'",
 
     # Supprime toute config DHCP existante
      "sudo sed -i '/^iface ens32 inet/d' /etc/network/interfaces",
      "sudo sed -i '/^allow-hotplug ens32/d' /etc/network/interfaces",

      # Ajoute la nouvelle configuration en IP statique
      "sudo tee -a /etc/network/interfaces <<EOF",
      "auto ens32",
      "iface ens32 inet static",
      "    address 192.168.62.110",
      "    netmask 255.255.255.0",
      "    gateway 192.168.62.2",
      "    dns-nameservers 8.8.8.8",
      "EOF",

      # Appliquer les changements sans redémarrer la VM
      "sudo systemctl restart networking",
    
      # Vérification après modification
      "ip a show ens32"
    ]
  }

 
}

