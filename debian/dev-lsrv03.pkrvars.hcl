# Variables pour personnaliser le déploiement

vm_name = "M2L-LSRV03"

vm_hostname = "m2l-lsrv03"


vm_domain = "m2l.lan"

network_name = "VM Network"

network_name2 = "VLAN"


ip_wait_timeout = "25m"


networkcard1 = {
  name    = "ens32"
  ip      = "192.168.62.102"
  netmask = "255.255.255.0"
  gateway = "192.168.62.2"
  dns     = "8.8.8.8"
}
