#!/bin/bash

# setup-sudo.sh - Automatically configure passwordless sudo
# Run this after cloning dotfiles on a new Ubuntu machine

set -e  # Exit on any error

echo "Setting up passwordless sudo..."

# Get current user
USER=$(whoami)
if [[ -z "$USER" ]]; then
    echo "Could not determine current user"
    exit 1
fi

echo "Configuring sudo for user: $USER"

# Check if we're already in sudoers
if sudo grep -q "^$USER ALL=(ALL) NOPASSWD:ALL$" /etc/sudoers.d/90-cloud-init-users; then
    echo "Passwordless sudo already configured!"
    exit 0
fi

# Create sudoers.d file safely
SUDOERS_FILE="/etc/sudoers.d/90-dotfiles-$USER"
cat > "$SUDOERS_FILE" << EOF
# Passwordless sudo for $USER (created by dotfiles)
$USER ALL=(ALL) NOPASSWD:ALL
EOF

# Set correct permissions (required for sudoers files)
sudo chmod 0440 "$SUDOERS_FILE"

# Validate syntax
if sudo visudo -cf "$SUDOERS_FILE"; then
    echo "Sudoers syntax validated successfully!"
else
    echo "Sudoers syntax error! Reverting..."
    sudo rm -f "$SUDOERS_FILE"
    exit 1
fi

echo "Passwordless sudo configured for $USER!"
echo "   Test it: sudo ls"
echo ""
echo "Run 'sudo ls' to verify (should work without password)"