#!/bin/bash
# my-gnome-fedora-pkgs.sh - install my favorite GNOME packages in Fedora
# Disclaimer: Use on your own risk!
set -xeuo pipefail

# d-feet: DBus GUI
# gdk-pixbuf2-modules-extra required for icons in mtpaint,
#   etc, see https://www.reddit.com/r/Fedora/comments/1gfildw/solved_fedora_41gnome_47_missing_icons_broken/?rdt=55345
sudo dnf install gnome-terminal terminator gnome-tweaks gnome-extensions-app \
	gnome-shell-extension-dash-to-panel gnome-shell-extension-system-monitor-applet \
	d-feet terminus-fonts egl-utils \
	gdk-pixbuf2-modules-extra
exit 0
