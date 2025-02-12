# Variables pour personnaliser le déploiement
esxi_host = "192.168.3.10"

vm_name = "M2L-LSRV05"

vm_hostname = "m2l-lsrv05"

vm_domain = "m2l.lan"

ip_wait_timeout = "25m"

network_name = "VM IMC"

network_name2 = "VMDMZ"

networkcard1 = {
  name    = "ens32"
  ip      = "192.168.3.93"
  netmask = "255.255.255.0"
  gateway = "192.168.3.1"
  dns     = "8.8.8.8"
}

networkcard2 = {
    name    = "ens33"
    ip      = "192.168.0.1"
    netmask = "255.255.255.240"
    gw      = "192.168.0.14"
    dns     = "8.8.8.8"
  }


