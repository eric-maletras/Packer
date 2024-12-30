variable "iso_url" {
  default = "/var/ISOs/WinServ2019.iso"
}

variable "iso_checksum" {
  default = "sha256:3214bb306884cbb0242117343dd4f0606c6a22b5600e5514e1447a11a29379ae"
#  default = "sha256:fe8baab88be3b28711ff06d454ab93ddf1b15fb5822b65534fbb3bfbabf1515f"
}

variable "admin_password" {
  default = "Btssio75000"
}

source "vsphere-iso" "windows_server_2019" {
  host		       = "192.168.62.100"
  vcenter_server       = "192.168.62.100"
  username             = "root"
  password             = "Btssio75000!"
  insecure_connection  = true

  datastore            = "datastore1"

  iso_url            = var.iso_url
  iso_checksum       = var.iso_checksum


  communicator       = "winrm"
  winrm_username     = "Administrateur"
  winrm_password     = var.admin_password
  winrm_host         = "192.168.62.218"
  winrm_insecure     = true
  winrm_use_ssl      = false
  winrm_port         = 5985
  winrm_timeout      = "30m"

  ssh_username       = "Administrateur"
  ssh_password       = var.admin_password
  ssh_wait_timeout   = "30m"

  vm_name            = "WindowsServer2019"
  guest_os_type      = "windows8Server64Guest"
  
  iso_paths           = ["[datastore1] vmimages/tools-isoimages/windows.iso"]

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


  network_adapters {
    network      = "VM Network"
    network_card = "e1000"
  }
  
  remove_cdrom = "true"
  
  floppy_files         = ["./setup/autounattend.xml"]

  // Commande pour arrêter le système (ici, on effectue un SYSPREP avant l'arrêt) 
  // arrêt seul : shutdown_command = "shutdown /s /t 30 /f"
 // shutdown_command = "C:\\Windows\\system32\\Sysprep\\sysprep.exe /generalize /oobe /shutdown /unattend:a:\\windows-autounattend.xml"
  shutdown_timeout = "20m"
}

build {
  sources = ["source.vsphere-iso.windows_server_2019"]
 
  provisioner "shell" {
  inline = [
    "echo 'Provisioning PowerShell test'"
  ]
  }
#  provisioner "powershell" {
#    inline = [
#      "Write-Host 'Début de l'exécution du provisioner PowerShell'",

      # Appliquer la stratégie d'exécution pour permettre l'exécution de scripts non signés
#      "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force",

      # Attendre que le lecteur de disquette soit monté
#      "Start-Sleep -Seconds 10",  # Temps d'attente pour s'assurer que la disquette est montée

      # Vérifier que le script existe sur le disque
#      "if (Test-Path 'A:\\install-vmtools.ps1') {",
#      "  Write-Host 'Script found, executing...'",
#      "  # Exécuter le script PowerShell depuis le lecteur de disquette",
#      "  & 'A:\\install-vmtools.ps1'",
#      "} else {",
#      "  Write-Host 'Script not found on floppy drive.'",
#      "}"
#    ]
#  }
  
#  // Initier un redémarrage de la machine
#  provisioner "windows-restart" {
#    restart_timeout = "10m"
#  }
}


