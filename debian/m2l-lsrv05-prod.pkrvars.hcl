# Variables pour personnaliser le déploiement
esxi_host = "192.168.3.10"

vm_name = "M2L-LSRV05-A"

vm_hostname = "m2l-lsrv05"

vm_domain = "labo.lan"

network_name = "VM IMC"

network_name2 = "VM Network"

networkcard1 = {
  name    = "ens32"
  ip      = "192.168.3.78"
  netmask = "255.255.255.0"
  gateway = "192.168.3.1"
  dns     = "8.8.8.8"
}


