# Chemin du registre pour l'autologon
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

# Supprimer les clés liées à l'autologon
Write-Output "Suppression de l'Autologon..."
Remove-ItemProperty -Path $RegistryPath -Name "AutoAdminLogon" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path $RegistryPath -Name "DefaultUserName" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path $RegistryPath -Name "DefaultPassword" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path $RegistryPath -Name "DefaultDomainName" -ErrorAction SilentlyContinue

# Vérification
if (-not (Get-ItemProperty -Path $RegistryPath -Name "AutoAdminLogon" -ErrorAction SilentlyContinue)) {
    Write-Output "Autologon désactivé avec succès."
} else {
    Write-Warning "Impossible de désactiver l'autologon."
}
