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

variable ip_wait_timeout {
  type = string
  default = "15m"
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

variable "networkcard1" {
  type = object({
    name    = string
    ip      = string
    netmask = string
    gateway = string
    dns     = string
  })
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
  ssh_timeout  = "20m"

  ip_wait_timeout = var.ip_wait_timeout

  # Configuration du snapshot après la création
  create_snapshot  = true
  snapshot_name    = "InitSnapshot"

  shutdown_timeout = "60m"

}


build {
  sources = ["source.vsphere-iso.debian_12"] 
  
  provisioner "shell" {
  inline = [
    "echo 'Début du provisionnement...'",

    "# Sauvegarder le fichier de configuration existant",
    "echo 'Sauvegarde du fichier /etc/network/interfaces en cours...'",
    "sudo cp /etc/network/interfaces /etc/network/interfaces.bak",
    "echo 'Sauvegarde effectuée : /etc/network/interfaces.bak'",

    "# Suppression des lignes existantes pour l'interface (hotplug et configuration DHCP)",
    "echo 'Suppression des lignes de configuration existantes pour ${var.networkcard1.name}...'",
    "sudo sed -i '/^hotplug ${var.networkcard1.name}/d' /etc/network/interfaces",
    "sudo sed -i '/^iface ${var.networkcard1.name} inet dhcp/d' /etc/network/interfaces",
    "echo 'Suppression terminée'",

    "# Ajout de la configuration statique pour l'interface",
    "echo 'Ajout de la configuration statique pour ${var.networkcard1.name}...'",
    "sudo sh -c 'echo \"\" >> /etc/network/interfaces'",
    "sudo sh -c 'echo \"# BEGIN ANSIBLE MANAGED BLOCK: Configuration de ${var.networkcard1.name}\" >> /etc/network/interfaces'",
    "sudo sh -c 'echo \"auto ${var.networkcard1.name}\" >> /etc/network/interfaces'",
    "sudo sh -c 'echo \"iface ${var.networkcard1.name} inet static\" >> /etc/network/interfaces'",
    "sudo sh -c 'echo \"    address ${var.networkcard1.ip}\" >> /etc/network/interfaces'",
    "sudo sh -c 'echo \"    netmask ${var.networkcard1.netmask}\" >> /etc/network/interfaces'",
    "sudo sh -c 'echo \"    gateway ${var.networkcard1.gateway}\" >> /etc/network/interfaces'",
    "sudo sh -c 'echo \"    dns-nameservers ${var.networkcard1.dns}\" >> /etc/network/interfaces'",
    "sudo sh -c 'echo \"# END ANSIBLE MANAGED BLOCK: Configuration de ${var.networkcard1.name}\" >> /etc/network/interfaces'",
    "echo 'Configuration statique ajoutée pour ${var.networkcard1.name}'",
    "echo 'Provisionnement terminé.'"
   ]
 }

}

