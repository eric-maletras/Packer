# les applications a installés: #

wget -O - https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" |  tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install packer 

pip install pyvmomi --break-system-packages

curl -L https://github.com/vmware/govmomi/releases/latest/download/govc_Linux_x86_64.tar.gz -o govc.tar.gz \
tar -xvzf govc.tar.gz \
mv govc /usr/local/bin/ 

# Plan d'adressage IMC #
- infra A
  + M2L-WSRV01: 192.168.3.90
  + M2L-WSRV02: 192.168.3.91
  + M2L-LSRV03: 192.168.3.92
  + M2L-LSRV05: 192.168.3.93
  + M2L-LSRV07: 192.168.3.95
- infra B
  + M2L-WSRV01: 192.168.3.100
  + M2L-WSRV02: 192.168.3.101
  + M2L-LSRV03: 192.168.3.102
  + M2L-LSRV05: 192.168.3.103
  + M2L-LSRV07: 192.168.3.105
- infra C
  + M2L-WSRV01: 192.168.3.110
  + M2L-WSRV02: 192.168.3.111
  + M2L-LSRV03: 192.168.3.112
  + M2L-LSRV05: 192.168.3.113
  + M2L-LSRV07: 192.168.3.115
- infra D
  + M2L-WSRV01: 192.168.3.120
  + M2L-WSRV02: 192.168.3.121
  + M2L-LSRV03: 192.168.3.122
  + M2L-LSRV05: 192.168.3.123
  + M2L-LSRV07: 192.168.3.125
