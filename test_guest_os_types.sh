#!/bin/bash

# Réseau par défaut à utiliser (adapter si nécessaire)
NET="VM Network"
CPU=1
MEM=512
TMP_VM_PREFIX="govc-test-os"

echo "🔍 Test des guest_os_type avec affichage du système correspondant..."

declare -A GUEST_OS_MAP=(
  [windows7Guest]="Windows 7 32-bit"
  [windows7_64Guest]="Windows 7 64-bit"
  [windows8Guest]="Windows 8 32-bit"
  [windows8_64Guest]="Windows 8 / 8.1 64-bit"
  [windows9Guest]="Windows 10 32-bit"
  [windows9_64Guest]="Windows 10 64-bit"
  [windows11_64Guest]="Windows 11 64-bit"
  [windows2008Guest]="Windows Server 2008 32-bit"
  [windows2008_64Guest]="Windows Server 2008 64-bit"
  [windows2008srv_64Guest]="Windows Server 2008 R2"
  [windows2012Guest]="Windows Server 2012"
  [windows2012srv_64Guest]="Windows Server 2012 R2"
  [windows2016srv_64Guest]="Windows Server 2016"
  [windows2019srv_64Guest]="Windows Server 2019"
  [windows2022srv_64Guest]="Windows Server 2022"
  [windowsHyperVGuest]="Microsoft Hyper-V"
  [centos64Guest]="CentOS 6 64-bit"
  [centos7_64Guest]="CentOS 7 64-bit"
  [centos8_64Guest]="CentOS 8 64-bit"
  [rhel7_64Guest]="Red Hat Enterprise Linux 7 64-bit"
  [rhel8_64Guest]="Red Hat Enterprise Linux 8 64-bit"
  [rhel9_64Guest]="Red Hat Enterprise Linux 9 64-bit"
  [debian8_64Guest]="Debian 8 Jessie 64-bit"
  [debian9_64Guest]="Debian 9 Stretch 64-bit"
  [debian10_64Guest]="Debian 10 Buster 64-bit"
  [debian11_64Guest]="Debian 11 Bullseye 64-bit"
  [debian12_64Guest]="Debian 12 Bookworm 64-bit"
  [ubuntu64Guest]="Ubuntu (12.04 → 22.04) 64-bit"
  [ubuntuGuest]="Ubuntu (12.04 → 22.04) 32-bit"
  [fedora64Guest]="Fedora 64-bit"
  [opensuse64Guest]="openSUSE 64-bit"
  [sles12_64Guest]="SUSE Linux Enterprise 12 64-bit"
  [sles15_64Guest]="SUSE Linux Enterprise 15 64-bit"
  [freebsd11_64Guest]="FreeBSD 11.x 64-bit"
  [freebsd12_64Guest]="FreeBSD 12.x 64-bit"
  [oracleLinux8_64Guest]="Oracle Linux 8 64-bit"
  [oracleLinux9_64Guest]="Oracle Linux 9 64-bit"
  [otherLinux64Guest]="Generic Linux 64-bit"
  [otherGuest]="Other 32-bit OS"
  [other3xLinux64Guest]="Other Linux 3.x 64-bit"
  [vmkernel6Guest]="VMware ESXi 6.x"
  [vmkernel7Guest]="VMware ESXi 7.x"
  [vmkernel8Guest]="VMware ESXi 8.x"
)

for guest in "${!GUEST_OS_MAP[@]}"; do
  OS_NAME="${GUEST_OS_MAP[$guest]}"
  VM_NAME="${TMP_VM_PREFIX}-${guest}"
  echo -n "🧪 $guest ($OS_NAME) : "

  govc vm.create -on=false -g="$guest" -c=$CPU -m=$MEM -net="$NET" "$VM_NAME" >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo "✅ supporté"
    govc vm.destroy "$VM_NAME" >/dev/null 2>&1
  else
    echo "❌ non supporté"
  fi
done

echo "✅ Test terminé."
