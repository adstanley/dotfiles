#!/usr/bin/env bash
# This script sets up a no-password sudo configuration for the current user.

# Check if running as root
if [[ "$EUID" -ne 0 ]]; then
  echo "This script requires root privileges. Elevating..."
  exec sudo -s "$0" "$@"
fi

# Get the current user
current_user=$(whoami)

# Create a no-password sudo configuration for the current user
echo "$current_user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/no_password_sudo
