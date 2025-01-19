#!/bin/bash
# my-gnome-fedora-pkgs.sh - install my favorite GNOME packages in Fedora
# Disclaimer: Use on your own risk!
set -xeuo pipefail

# d-feet: DBus GUI
sudo dnf install gnome-terminal terminator gnome-tweaks gnome-extensions-app \
	gnome-shell-extension-dash-to-panel gnome-shell-extension-system-monitor-applet \
	d-feet terminus-fonts egl-utils
exit 0
