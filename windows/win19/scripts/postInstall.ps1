# Script PowerShell pour configurer la carte réseau avec une IP statique

$DNSDomain = "labo.lan"        # Domaine DNS (FQDN)
$Hostname = "M2L-WSRV01"       # Nom de la VM

# Désactiver l'expiration du mot de passe
Write-Host "Desactivation du mot de passe"
Start-Process -FilePath "cmd.exe" -ArgumentList "/c net accounts /maxpwage:unlimited" -Verb RunAs -Wait

Write-Host "Activation du bureau a distance"
# Activer le Bureau à Distance
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 0

# Activer ou ajouter les règles RDP
if (Get-NetFirewallRule -Name "RemoteDesktop-UserMode-In-TCP" -ErrorAction SilentlyContinue) {
    Enable-NetFirewallRule -Name "RemoteDesktop-UserMode-In-TCP"
    Enable-NetFirewallRule -Name "RemoteDesktop-UserMode-In-UDP"
} else {
    New-NetFirewallRule -DisplayName "Allow RDP" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow
}


# Attendre quelques secondes pour que le pare-feu soit bien initialisé
#Write-Host "Pause 5 s"
#Start-Sleep -Seconds 5

Write-Host "Autorisation du Ping"
New-NetFirewallRule -DisplayName "Allow Ping Inbound" -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow
New-NetFirewallRule -DisplayName "Allow Ping Outbound" -Direction Outbound -Protocol ICMPv4 -Action Allow
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True


function Disable-IeEscForUsers {
    # Liste des utilisateurs pour lesquels IE ESC doit être désactivé
    $users = @("admins", "users")
    
    # Désactiver IE ESC pour les administrateurs
    if($users.Contains("admins")){
        $adminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
        if (Test-Path $adminKey) {
            Set-ItemProperty -Path $adminKey -Name "IsInstalled" -Value 0
            Write-Host "IE ESC désactivé pour les administrateurs."
        } else {
            Write-Host "La clé d'IE ESC pour les administrateurs n'existe pas."
        }
    }

    # Désactiver IE ESC pour les utilisateurs standard
    if($users.Contains("users")){
        $userKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
        if (Test-Path $userKey) {
            Set-ItemProperty -Path $userKey -Name "IsInstalled" -Value 0
            Write-Host "IE ESC désactivé pour les utilisateurs."
        } else {
            Write-Host "La clé d'IE ESC pour les utilisateurs n'existe pas."
        }
    }
}

# Appeler la fonction pour désactiver IE ESC
Write-Host "Desactivation de la sécurité d'IE"
Disable-IeEscForUsers

# Modification du nom de l'ordinateur
Write-Host "Modification du nom"
Rename-Computer -NewName $Hostname -Force
# Définir le suffixe DNS pour la machine
Write-Host "Modification du suffice DNS"
Set-DnsClientGlobalSetting -SuffixSearchList $DNSDomain

# Définir le suffixe DNS pour l'interface spécifique
#Set-DnsClient -InterfaceAlias $InterfaceAlias -ConnectionSpecificSuffix $DNSDomain

# Chemin du registre pour le suffixe DNS principal
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"

# Définir le suffixe DNS principal
Set-ItemProperty -Path $regPath -Name "NV Domain" -Value $DNSDomain


# Autoriser l'écriture sur le second disque dur
# Étape 1 : Récupérer le DiskNumber pour le disque ayant la lettre F
$driveLetter = "F"
$partition = Get-Partition -DriveLetter $driveLetter
if ($partition) {
    $diskNumber = $partition.DiskNumber
    Write-Output "Le n° est : $diskNumber"
} else {
    Write-Output "Le lecteur $driveLetter est introuvable."
}

if ($diskNumber -ne $null) {
    Write-Host "Le disque avec la lettre $driveLetter est associé au numéro $diskNumber."

    # Étape 2 : Enlever l'attribut 'lecture seule' du disque
    Write-Host "Suppression de l'attribut 'lecture seule'..."
    Set-Disk -Number $diskNumber -IsReadOnly $false 
    Write-Host "L'attribut 'lecture seule' a été supprimé."

    # Étape 3 : Configurer les permissions sur le volume
#    Write-Host "Configuration des permissions pour tout le monde (lecture et exécution)..."
#    Set-Volume -DriveLetter $driveLetter -FileSystemAccessRule "Everyone" -AccessRights ReadAndExecute -AccessControlType Allow
#    Write-Host "Les permissions ont été configurées avec succès sur le volume $driveLetter."

} else {
    Write-Host "Erreur : Aucun disque trouvé avec la lettre $driveLetter."
}



Write-Host "Fin du script"
Start-Sleep -Seconds 5
