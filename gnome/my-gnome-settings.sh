#!/bin/bash
# my-gnome-settings.sh - my favorite gnome settings
# WARNING! Requires installed Verdana font (from Windows)
# Disclaimer: Use on your own risk!
set -xeuo pipefail

# enabling font hinting and disabling anti-alias
gsettings set org.gnome.desktop.interface font-antialiasing 'none'
gsettings set org.gnome.desktop.interface font-hinting 'full'
gsettings set org.gnome.desktop.interface font-rendering manual

# using Verdana font
gsettings set org.gnome.desktop.interface document-font-name 'Verdana 11'
gsettings set org.gnome.desktop.interface font-name 'Verdana 11'
# using good looking bold Terminus font
gsettings set org.gnome.desktop.interface monospace-font-name 'Terminus Bold 12'
# force scrollbars
gsettings set org.gnome.desktop.interface overlay-scrolling false
# other settings
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
# Ptyxis terminal
gsettings set org.gnome.Ptyxis default-columns 120
gsettings set org.gnome.Ptyxis default-rows 34
gsettings set org.gnome.Ptyxis restore-window-size false

# commented out - too destructive
#gsettings set org.gnome.shell favorite-apps "['org.mozilla.firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.Ptyxis.desktop', 'org.gnome.tweaks.desktop', 'org.gnome.Settings.desktop', 'org.gnome.Extensions.desktop']"
exit 0
