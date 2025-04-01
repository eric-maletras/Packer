#!/bin/bash

echo "Création Infra D M2L-WSRV01"
#packer build --force --on-error=abort --var-file=windows/win19/D-wsrv01.pkrvars.hcl windows/win19/windows-server-2019.pkr.hcl

echo "**************************************************************"
echo "Creation Infra D M2L-WSRV02"
#packer build --force --on-error=abort --var-file=windows/win19/D-wsrv02.pkrvars.hcl windows/win19/windows-server-2019.pkr.hcl

echo "***************************************************************"
echo "************   VM Linux ***************************************"
echo "***************************************************************"
echo "***********   D-lsrv03  **************************************" 
packer build --force --on-error=abort --var-file=debian/D-lsrv03.pkrvars.hcl debian/debian12-vm.pkr.hcl

packer build --force --on-error=abort --var-file=debian/D-lsrv05.pkrvars.hcl debian/debian12-vm.pkr.hcl
