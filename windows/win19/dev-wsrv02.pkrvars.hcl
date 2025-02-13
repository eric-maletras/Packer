
esxi_host = "192.168.62.100"

VM_name = "M2L-WSRV02"

#vm_tool_path = "[datastore1] vmimages/tools-isoimages/windows.iso"

esxi_network0 = "VM Network"

ip_network0 = {
    interface = "Ethernet0"
    ip      = "192.168.62.131"
    netmask = "255.255.255.0"
    gw      = "192.168.62.2"
    dns     = "192.168.62.2"
  }

esxi_network1 = "VLAN"

ip_network1 = {
    interface = "Ethernet1"
    ip      = "172.16.2.58"
    netmask = "255.255.255.192"
    gw      = "172.16.2.62"
    dns     = "172.16.2.61"
  }


#ps1_script_path = "C:/Windows/Temp/set_static_ip.ps1"
