# Installer python ou vérifier qu'il y est
write-output "Installation de python 3.11"

New-Item -ItemType Directory -Force -Path c:\temp
Invoke-WebRequest -uri https://www.python.org/ftp/python/3.13.1/python-3.13.1-amd64.exe -outfile c:\temp\python.exe


# On fait une install silencieuse dans "c:\program files\311" (pour la version 311)
c:\temp\python.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
