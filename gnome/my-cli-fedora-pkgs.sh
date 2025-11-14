#!/bin/bash
# my-cli-fedora-pkgs.sh - My favorite CLI packages in fedora
# Disclaimer: Use on your own risk!
set -xeuo pipefail

# fastfetch - clone of neofetch, ncdu - disk usage utility
sudo dnf install fastfetch jq mc lynx ncdu
exit 0
