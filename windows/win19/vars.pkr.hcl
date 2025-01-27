
variable "esxi_host" {
  type = string
  default = "192.168.62.100"
}

variable "esxi_user" {
  type = string
}

variable "esxi_password" {
  type = string
}

variable "datastore" {
  type = string
}

variable "iso_path" {
  type = string
}

#variable "iso_checksum" {
#  type = "sha256:3214bb306884cbb0242117343dd4f0606c6a22b5600e5514e1447a11a29379ae"
#}

variable "VM_name" {
  type = string
}

variable "windows_user" {
  type = string
}

variable "windows_password" {
  type = string
}

variable "vm_tool_path" {
  type = string
}

variable "esxi_network0" {
  type = string
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

variable "ip_network1" {
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

variable "ps1_script_path" {
  type = string
}

