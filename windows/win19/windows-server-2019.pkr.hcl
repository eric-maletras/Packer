
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

variable "iso_url" {
  default = "/var/ISOs/WinServ2019.iso"
}

variable "iso_checksum" {
  default = "sha256:3214bb306884cbb0242117343dd4f0606c6a22b5600e5514e1447a11a29379ae"
}

variable "VM_name" {
  default = "M2L-WSRV02"
}

variable "windows_user" {
  default = "administrateur"
}

variable "windows_password" {
  default = "Btssio75000"
}

variable "vm_tool_path" {
  default = "[datastore1] vmimages/tools-isoimages/windows.iso"
}

variable "esxi_network0" {
  default = "VM Network"
}

variable "ip_network0" {
  default = {
    interface = "Ethernet0"
    ip      = "192.168.62.129"
    netmask = "255.255.255.0"
    gw      = "192.168.62.2"
    dns     = "192.168.62.2"
  }
}

variable "ip_network1" {
  default = {
    interface = "Ethernet1"
    ip      = "172.16.2.58"
    netmask = "255.255.255.192"
    gw      = "172.16.2.62"
    dns     = "172.16.2.61"
  }
}


variable "esxi_network1" {
  default = "VLAN"
}

variable "ps1_script_path" {
  default = "C:/Windows/Temp/set_static_ip.ps1"
}

source "vsphere-iso" "windows_server_2019" {
  host		       = var.esxi_host
  vcenter_server       = var.esxi_host
  username             = var.esxi_user
  password             = var.esxi_password
  insecure_connection  = true

  datastore            = var.datastore

  iso_url            = var.iso_url
  iso_checksum       = var.iso_checksum

  communicator       = "winrm"
  winrm_username     = var.windows_user
  winrm_password     = var.windows_password

  winrm_insecure     = true
  winrm_use_ssl      = false
  winrm_port         = 5985
  winrm_timeout      = "30m"

  ssh_username       = var.windows_user
  ssh_password       = var.windows_password
  ssh_wait_timeout   = "30m"

  vm_name            = var.VM_name
  guest_os_type      = "windows8Server64Guest"
  
  iso_paths           = [var.vm_tool_path]

  //Config de la machine
  CPUs			= 2
  RAM			= 4096
  disk_controller_type	= ["lsilogic-sas"]
  firmware             = "bios"
  
  # Configuration du stockage
  storage {
    disk_size             = 51200  # Taille du disque en Mo (50 Go)
    disk_thin_provisioned = true  # Activation du thin provisioning
  }

  storage {
    disk_size             = 61440  # Taille du disque en Mo (60 Go)
    disk_thin_provisioned = true  # Activation du thin provisioning
  }

  network_adapters {
    network      = var.esxi_network0
    network_card = "e1000"
  }
  network_adapters {
    network      = var.esxi_network1
    network_card = "e1000"
  }

  
  remove_cdrom = "true"
  
  floppy_files         = [
    "./scripts/autounattend.xml",
    "./scripts/install-vm-tools.cmd",
    "./scripts/enable-winrm.ps1"
  ]


  shutdown_timeout = "20m"
}

build {
  sources = ["source.vsphere-iso.windows_server_2019"]

  provisioner "powershell" {
    script = "scripts/postInstall.ps1"
  }

  provisioner "powershell" {
    script = "scripts/installChocolatey.ps1"
  }

  #Initier un redémarrage de la machine
  provisioner "windows-restart" {
    restart_timeout = "3m"
  }
  
   provisioner "file" {
    source      = "scripts/executeChocolatey.ps1"
    destination = "C:/Users/Administrateur/Desktop/executeChocolatey.ps1"
   }

  provisioner "powershell" {
    script = "scripts/executeChocolatey.ps1"
  }

   provisioner "powershell" {
    script = "scripts/removeAutologon.ps1"
   }

#   provisioner "powershell" {
#    script = "scripts/installPython.ps1"
#   }
   
   provisioner "file" {
    source      = "scripts/ipStatiqueEnthern0.ps1"
    destination = var.ps1_script_path
   }

   provisioner "powershell" {
    inline = [
      "powershell.exe -ExecutionPolicy Bypass -File ${var.ps1_script_path} -InterfaceAlias ${var.ip_network1.interface} -IpAddress ${var.ip_network1.ip} -SubnetMask ${var.ip_network1.netmask} -Gateway ${var.ip_network1.gw} -DNSServer ${var.ip_network1.dns}"
#      "powershell.exe -ExecutionPolicy Bypass -File ${var.ps1_script_path} -InterfaceAlias ${var.ip_network0.interface} -IpAddress ${var.ip_network0.ip} -SubnetMask ${var.ip_network0.netmask} -Gateway ${var.ip_network0.gw} -DNSServer ${var.ip_network0.dns}"
    ]
   }    
   
#   provisioner "shell" {
#     inline = ["shutdown /s /t 0"]
#   }

#  provisioner "shell" {
#    inline = [
#      "govc snapshot.create -vm=${var.VM_name} -u https://${var.esxi_user}:={var.esxi_password}@${var.esxi_host} -k snapshot-name"
#    ]
#  }
}
