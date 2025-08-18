#!/usr/bin/env bash

# Check if running as root
if [[ "$EUID" -ne 0 ]]; then
  echo "This script requires root privileges. Elevating..."
  exec sudo -s "$0" "$@"
fi

# remove all snap packages
snap list | awk '{print $1}' | xargs -r snap remove

# Remove snapd package
echo "Removing snapd package..."
apt remove --purge -y snapd

# Ensure snapd is not automatically installed again
echo "Holding snapd package to prevent reinstallation..."
apt-mark hold snapd

apt update && apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo