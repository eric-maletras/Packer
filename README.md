les applications a installés: \
wget -O - https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" |  tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install packer 

pip install pyvmomi --break-system-packages

curl -L https://github.com/vmware/govmomi/releases/latest/download/govc_Linux_x86_64.tar.gz -o govc.tar.gz \
tar -xvzf govc.tar.gz \
mv govc /usr/local/bin/ 
