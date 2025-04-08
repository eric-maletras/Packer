#!/bin/bash

echo "Création Infra A M2L-WSRV01"
packer build --force --on-error=abort --var-file=windows/win19/B-wsrv01.pkrvars.hcl windows/win19/windows-server-2019.pkr.hcl

echo "**************************************************************"
echo "Creation Infra A M2L-WSRV02"
packer build --force --on-error=abort --var-file=windows/win19/B-wsrv02.pkrvars.hcl windows/win19/windows-server-2019.pkr.hcl

echo "***************************************************************"
echo "************   VM Linux ***************************************"
echo "***************************************************************"
echo "***********   A-lsrv03  **************************************" 
packer build --force --on-error=abort --var-file=debian/B-lsrv03.pkrvars.hcl debian/debian12-vm.pkr.hcl

packer build --force --on-error=abort --var-file=debian/B-lsrv05.pkrvars.hcl debian/debian12-vm.pkr.hcl
