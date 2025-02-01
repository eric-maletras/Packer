# Locale and Keyboard setup
d-i debian-installer/locale string fr_FR.UTF-8
d-i console-setup/ask_detect boolean false
d-i keyboard-configuration/xkb-keymap select fr
d-i keyboard-configuration/layoutcode string fr
d-i keyboard-configuration/variantcode string latin9
d-i console-setup/charmap select UTF-8


# Configuration réseau (choix automatique de l'interface)
d-i netcfg/choose_interface select ens32
d-i netcfg/disable_dhcp boolean false

# Nom d'hôte et domaine
d-i netcfg/get_hostname string debian12
d-i netcfg/get_domain string local

# Configuration des miroirs Debian
d-i mirror/country string manual
d-i mirror/http/hostname string ftp.fr.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string

# Partitionnement automatique avec LVM
d-i partman-auto/disk string /dev/sda
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-md/device_remove_md boolean true
d-i partman-auto/method string lvm

d-i partman-auto/choose_recipe select atomic

d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-md/confirm boolean true
d-i partman-partitioning/confirm_write_new_label boolean true

# Configuration de l'horloge
d-i clock-setup/utc boolean true
d-i time/zone string Europe/Paris
d-i clock-setup/ntp boolean true

# Comptes utilisateurs
# Compte root
d-i passwd/root-login boolean true
d-i passwd/make-user boolean true
d-i passwd/root-password ${root_password}
d-i passwd/root-password-again password ${root_password}

d-i passwd/user-fullname string admin1
d-i passwd/username string admin1
d-i passwd/user-password password Btssio75000
d-i passwd/user-password-again password Btssio75000

# Disable CD-ROM entries (primary method)
#d-i apt-setup/disable-cdrom-entries boolean true


# Installation minimale avec OpenSSH
tasksel tasksel/first multiselect minimal
d-i pkgsel/include string openssh-server vim git curl python3 python3-pip sudo
d-i pkgsel/upgrade select none
d-i base-installer/install-recommends boolean false

# Installation de GRUB
d-i grub-installer/only_debian boolean true
d-i grub-installer/bootdev string default

# Fin de l'installation
d-i finish-install/reboot_in_progress note
d-i debian-installer/exit/poweroff boolean true

# Supprimer les références au CD-ROM et ajouter les miroirs Debian via late_command
d-i preseed/late_command string \
    rm -f /target/etc/apt/sources.list; \
    printf "deb http://deb.debian.org/debian bookworm main contrib non-free-firmware\n" > /target/etc/apt/sources.list; \
    printf "deb-src http://deb.debian.org/debian bookworm main contrib non-free-firmware\n" >> /target/etc/apt/sources.list; \
    printf "deb http://security.debian.org/debian-security bookworm-security main contrib non-free-firmware\n" >> /target/etc/apt/sources.list; \
    printf "deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free-firmware\n" >> /target/etc/apt/sources.list; \
    printf "deb http://deb.debian.org/debian bookworm-updates main contrib non-free-firmware\n" >> /target/etc/apt/sources.list; \
    printf "deb-src http://deb.debian.org/debian bookworm-updates main contrib non-free-firmware\n" >> /target/etc/apt/sources.list; \
    printf "\nauto ens33\niface ens33 inet static\n    address 172.16.2.59\n    netmask 255.255.255.192\n    dns-nameservers 172.16.2.61\n" >> /target/etc/network/interfaces; \
    in-target sh -c "apt update && apt full-upgrade -y && apt autoremove -y && apt clean"

