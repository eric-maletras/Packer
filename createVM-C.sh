#!/bin/bash

echo "Création Infra C M2L-WSRV01"
#packer build --force --on-error=abort --var-file=windows/win19/C-wsrv01.pkrvars.hcl windows/win19/windows-server-2019.pkr.hcl

echo "**************************************************************"
echo "Creation Infra D M2L-WSRV02"
#packer build --force --on-error=abort --var-file=windows/win19/C-wsrv02.pkrvars.hcl windows/win19/windows-server-2019.pkr.hcl

echo "***************************************************************"
echo "************   VM Linux ***************************************"
echo "***************************************************************"
echo "***********   C-lsrv03  **************************************" 
packer build --force --on-error=abort --var-file=debian/C-lsrv03.pkrvars.hcl debian/debian12-vm.pkr.hcl

echo "***************************************************************"
echo "***********   C-lsrv05  **************************************"

packer build --force --on-error=abort --var-file=debian/C-lsrv05.pkrvars.hcl debian/debian12-vm.pkr.hcl
