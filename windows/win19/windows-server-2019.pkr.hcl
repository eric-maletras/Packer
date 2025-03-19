
variable "esxi_host" {
  type    =  string
}

variable "esxi_user" {
  type    = string
  default = "root"
}

variable "esxi_password" {
  type    = string 
  default = "Btssio75000!"
}

variable "datastore" {
  type    = string
  default = "datastore1"
}

variable "iso_path" {
  type    = string
  default = "[datastore1] ISOs/WinServ2019.iso"
}

#variable "iso_checksum" {
#  default = "sha256:3214bb306884cbb0242117343dd4f0606c6a22b5600e5514e1447a11a29379ae"
#}

variable "VM_name" {
  type    = string
}


variable "VM_domain" {
  type = string
  default = "labo.lan"
}

variable "windows_user" {
  type    = string
  default = "administrateur"
}

variable "windows_password" {
  type    = string
  default = "Btssio75000"
}

variable "vm_tool_path" {
  type    = string
  default = "[datastore1] vmimages/tools-isoimages/windows.iso"
}

variable "esxi_network0" {
  type    = string
}

variable "ip_network0" {
  type = object( {
    interface = string
    ip      = string
    netmask = string
    gw      = string
    dns     = string
  })
}

variable "esxi_network1" {
  type = string
}

variable "ip_network1" {
  type = object( {
    interface = string
    ip      = string
    netmask = string
    gw      = string
    dns     = string
  })
}


variable "ps1_script_path" {
  type = string
  default = "C:/Windows/Temp/set_static_ip.ps1"
}

variable "ip_wait_timeout" {
  type = string
  default = "30m"
}

source "vsphere-iso" "windows_server_2019" {
  host		       = var.esxi_host
  vcenter_server       = var.esxi_host
  username             = var.esxi_user
  password             = var.esxi_password
  insecure_connection  = true

  datastore            = var.datastore
  

  communicator       = "winrm"
  winrm_username     = var.windows_user
  winrm_password     = var.windows_password

  winrm_insecure     = true
  winrm_use_ssl      = false
  winrm_port         = 5985
  winrm_timeout      = "40m"

  pause_before_connecting = "60m"
  boot_wait          = "60m"
  ip_wait_timeout = var.ip_wait_timeout
  ip_wait_address = "0.0.0.0/0"

  ssh_username       = var.windows_user
  ssh_password       = var.windows_password
  ssh_wait_timeout   = "30m"

  vm_name            = var.VM_name
  guest_os_type      = "windows8Server64Guest"
  
  iso_paths           = [
    var.iso_path,
    var.vm_tool_path
  ]

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
  
  floppy_files         = [
    "/var/Packer/windows/win19/scripts/autounattend.xml",
    "/var/Packer/windows/win19/scripts/install-vm-tools.cmd",
    "/var/Packer/windows/win19/scripts/enable-winrm.ps1"
  ]

  # Création du snapshot
  create_snapshot       = true
  snapshot_name         = "init"

  shutdown_timeout = "40m"
  remove_cdrom = true
}

build {
  sources = ["source.vsphere-iso.windows_server_2019"] 

  provisioner "file" {
    source      = "/var/Packer/windows/win19/scripts/postInstall.ps1"
    destination = "C:\\Windows\\Temp\\postInstall.ps1"
  }

  provisioner "powershell" {
    inline = [
      "powershell.exe -File C:\\Windows\\Temp\\postInstall.ps1 -Hostname ${var.VM_name} -DNSDomain ${var.VM_domain}",
      "Remove-Item -Force C:\\Windows\\Temp\\postInstall.ps1"
    ]
  }

  provisioner "powershell" {
    script = "/var/Packer/windows/win19/scripts/installChocolatey.ps1"
  }

  #Initier un redémarrage de la machine
  provisioner "windows-restart" {
    restart_timeout = "5m"
  }
  
   provisioner "file" {
    source      = "/var/Packer/windows/win19/scripts/executeChocolatey.ps1"
    destination = "C:/Users/Administrateur/Desktop/executeChocolatey.ps1"
   }

  provisioner "powershell" {
    script = "/var/Packer/windows/win19/scripts/executeChocolatey.ps1"
  }

   provisioner "powershell" {
    script = "/var/Packer/windows/win19/scripts/removeAutologon.ps1"
   }

   
   provisioner "file" {
    source      = "/var/Packer/windows/win19/scripts/ipStatiqueEnthern0.ps1"
    destination = var.ps1_script_path
   }

   provisioner "powershell" {
    inline = [
      "powershell.exe -ExecutionPolicy Bypass -File ${var.ps1_script_path} -InterfaceAlias ${var.ip_network1.interface} -IpAddress ${var.ip_network1.ip} -SubnetMask ${var.ip_network1.netmask} -Gateway ${var.ip_network1.gw} -DNSServer ${var.ip_network1.dns}",
      "powershell.exe -ExecutionPolicy Bypass -File ${var.ps1_script_path} -InterfaceAlias ${var.ip_network0.interface} -IpAddress ${var.ip_network0.ip} -SubnetMask ${var.ip_network0.netmask} -Gateway ${var.ip_network0.gw} -DNSServer ${var.ip_network0.dns}"
    ]
   }    

}
