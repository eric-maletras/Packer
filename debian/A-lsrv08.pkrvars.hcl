# Variables pour personnaliser le déploiement

esxi_host = "192.168.3.10"

vm_name = "M2L-LSRV08"

vm_hostname = "m2l-lsrv08"
vm_domain = "m2l.lan"

network_name = "VM IMC"

network_name2 = "VM Network"


ip_wait_timeout = "25m"


networkcard1 = {
  name    = "ens32"
  ip      = "192.168.3.95"
  netmask = "255.255.255.0"
  gateway = "192.168.3.1"
  dns     = "8.8.8.8"
}

networkcard2 = {
    name    = "ens33"
    ip      = "172.16.2.50"
    netmask = "255.255.255.192"
    gw      = "172.16.2.62"
    dns     = "172.16.2.61"
  }
