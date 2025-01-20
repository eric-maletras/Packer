write-host "Intallation des logiciels via Chocolatey"

# Installer d'autres logiciels via Chocolatey
choco install googlechrome firefox 7zip python311 filezilla notepadplusplus winscp putty.install -y

# Vérification des logiciels installés
Write-Output "Logiciels installés via Chocolatey :"
choco list


write-host "fin de l'installation de chocolatey"
