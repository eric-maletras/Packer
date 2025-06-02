#!/bin/bash

echo "Création Infra A M2L-WSRV01"
echo "**************************************************************"
packer build --force --on-error=abort --var-file=windows/win19/A-wsrv01.pkrvars.hcl windows/win19/windows-server-2019.pkr.hcl

echo "**************************************************************"
echo "Creation Infra A M2L-WSRV02"
echo "**************************************************************"
packer build --force --on-error=abort --var-file=windows/win19/A-wsrv02.pkrvars.hcl windows/win19/windows-server-2019.pkr.hcl

echo "**************************************************************"
echo "Creation Infra A M2L-WSRV10"
echo "**************************************************************"
packer build --force --on-error=abort --var-file=windows/win19/A-wsrv01.pkrvars.hcl -var "VM_name=M2L-WSRV10" -var "DHCP=yes" windows/win19/windows-server-2019.pkr.hcl

echo "**************************************************************"
echo "Creation Infra A M2L-WSRV11"
echo "**************************************************************"
packer build --force --on-error=abort --var-file=windows/win19/A-wsrv01.pkrvars.hcl -var "VM_name=M2L-WSRV11" -var "DHCP=yes" windows/win19/windows-server-2019.pkr.hcl

echo "**************************************************************"
echo "Creation Infra A M2L-WSRV12"
echo "**************************************************************"
packer build --force --on-error=abort --var-file=windows/win19/A-wsrv01.pkrvars.hcl -var "VM_name=M2L-WSRV12" -var "DHCP=yes" windows/win19/windows-server-2019.pkr.hcl

echo "**************************************************************"
echo "Creation Infra A M2L-WSRV13"
echo "**************************************************************"
packer build --force --on-error=abort --var-file=windows/win19/A-wsrv01.pkrvars.hcl -var "VM_name=M2L-WSRV13" -var "DHCP=yes" windows/win19/windows-server-2019.pkr.hcl



echo "***************************************************************"
echo "************   VM Linux ***************************************"
echo "***************************************************************"
echo "***********   A-lsrv03  **************************************" 
packer build --force --on-error=abort --var-file=debian/A-lsrv03.pkrvars.hcl debian/debian12-vm.pkr.hcl
echo "***************************************************************"
echo "***********   A-lsrv05  **************************************"
packer build --force --on-error=abort --var-file=debian/A-lsrv05.pkrvars.hcl debian/debian12-vm.pkr.hcl
