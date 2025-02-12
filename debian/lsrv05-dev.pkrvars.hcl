# Variables pour personnaliser le déploiement
vm_name = "M2L-LSRV05"

vm_hostname = "m2l-lsrv05"

vm_domain = "labo.lan"

network_name = "VM Network"

network_name2 = "VLAN"

networkcard1 = {
  name    = "ens32"
  ip      = "192.168.62.110"
  netmask = "255.255.255.0"
  gateway = "192.168.62.2"
  dns     = "8.8.8.8"
}


