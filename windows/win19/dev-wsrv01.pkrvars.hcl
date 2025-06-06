
esxi_host = "192.168.62.100"

esxi_user = "root"

esxi_password = "Btssio75000!"

datastore = "datastore1"

iso_path = "[datastore1] ISOs/WinServ2019.iso"

VM_name = "M2L-WSRV01"

windows_user = "administrateur"

windows_password = "Btssio75000"

vm_tool_path = "[datastore1] vmimages/tools-isoimages/windows.iso"

esxi_network0 = "VM Network"

ip_network0 = {
    interface = "Ethernet0"
    ip      = "192.168.62.130"
    netmask = "255.255.255.0"
    gw      = "192.168.62.2"
    dns     = "192.168.62.2"
  }

esxi_network1 = "VLAN"

ip_network1 = {
    interface = "Ethernet1"
    ip      = "172.16.2.61"
    netmask = "255.255.255.192"
    gw      = "172.16.2.62"
    dns     = "127.0.0.1"
  }


ps1_script_path = "C:/Windows/Temp/set_static_ip.ps1"
