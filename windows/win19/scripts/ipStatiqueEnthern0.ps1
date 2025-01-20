# Script PowerShell pour configurer la carte réseau avec une IP statique

param (
    [string]$InterfaceAlias,
    [string]$IpAddress,
    [string]$SubnetMask,
    [string]$Gateway,
    [string]$DNSServer
)



#$InterfaceAlias = "Ethernet0"  # Nom de l'interface réseau à configurer (ex: Ethernet0, Ethernet1, etc.)
#$IPAddress = "192.168.62.129"     # Adresse IP statique
#SubnetMask = "255.255.255.0"  # Masque de sous-réseau
#$Gateway = "192.168.62.2"      # Passerelle par défaut
#$DNSServer = "192.168.62.2"         # Serveur DNS

write-host "Configuration interface" 
write-host $InterfaceAlias
# Obtenir l'interface réseau par son alias
$Interface = Get-NetAdapter -Name $InterfaceAlias

# Configurer l'adresse IP statique
New-NetIPAddress -InterfaceIndex $Interface.ifIndex -IPAddress $IPAddress -PrefixLength 24 -DefaultGateway $Gateway

# Configurer le serveur DNS
Set-DnsClientServerAddress -InterfaceIndex $Interface.ifIndex -ServerAddresses $DNSServer
