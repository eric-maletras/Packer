
Lancement du fichier avec variables:
Stage + M2L-WSRV01: packer build -force -on-error=abort -var-file=var-wsrv01-dev.pkrvars.hcl windows-server-2019.pkr.hcl
Stage + M2L-WSRV02: packer build -force -on-error=abort -var-file=var-wsrv02-dev.pkrvars.hcl windows-server-2019.pkr.hcl

