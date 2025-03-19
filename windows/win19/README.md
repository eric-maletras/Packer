IL faut copier les VM Tools de windows dans un dossier accessible par le script:
[datastore1] vmimages/tools-isoimages/windows.iso

ATTENTION Il faut avoir la bonne version de vsphere-iso\
AU premier lancement executer la commande packer init .


Lancement du fichier avec variables:\
packer build -force -on-error=abort -var-file=A-wsrv01.pkrvars.hcl windows-server-2019.pkr.hcl


