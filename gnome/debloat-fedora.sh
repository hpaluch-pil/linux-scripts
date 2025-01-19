#!/bin/bash
# debloat-fedora.sh - strongly opinionated script How to debloat GNOME in Fedora
# Disclaimer: Use on your own risk!
set -euo pipefail

[ `id -u` -eq 0 ] || {
	echo "This program must be run as 'root'" >&2
	exit 1
}
set -x
# Start with exception: install sane editor and default editor
dnf install --allowerasing vim-enhanced vim-default-editor mc

# Disable DNS stub and LLMNR (security risk)
f=/etc/systemd/resolved.conf
[ -f "$f" ] || {
	cat > $f <<EOF
[Resolve]
LLMNR=no
DNSStubListener=no
EOF
	systemctl restart systemd-resolved
}
# Disable cups/avahi - security risk
dnf remove cups cups-client avahi
# Disable chrony (global listen on NTP port)
timedatectl set-ntp false
# Disable fwupd - missing governance - security risk
dnf remove fwupd'*'

# Disable remote gnome software and/or flatpak
dnf remove gnome-software flatpak

# Geoclue is serious risk - getting your precise location at boot
systemctl mask geoclue
# other not needed stuff:
dnf remove fpaste sane'*' sssd'*'

# under Hypervisor kernel firmware is not needed (most of time).
[ ! -n `virt-what` ] || {
	dnf remove '*'-firmware-'*'
}
exit 0
