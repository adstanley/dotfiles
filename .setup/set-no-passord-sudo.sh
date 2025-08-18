#!/bin/bash

# Script to add passwordless sudo for the current user
# For Debian/Ubuntu systems

# Check if we're on a Debian-based system
if ! command -v apt-get &> /dev/null; then
    echo "This doesn't appear to be a Debian-based system. Exiting."
    exit 1
fi

# Get current username
USERNAME=$(whoami)

# Check if user is in sudo group
if ! groups "$USERNAME" | grep -q '\bsudo\b'; then
    echo "User $USERNAME is not in the sudo group. Adding..."
    sudo usermod -aG sudo "$USERNAME"
    echo "You may need to log out and back in for this change to take effect."
fi

# Create a temporary sudoers file
TMP_SUDOERS=$(mktemp)

# Check if the NOPASSWD entry already exists
if sudo grep -q "^$USERNAME.*NOPASSWD:.*ALL" /etc/sudoers; then
    echo "Passwordless sudo already configured for $USERNAME"
else
    # Create a backup of the sudoers file
    sudo cp /etc/sudoers /etc/sudoers.bak."$(date +%Y%m%d%H%M%S)"
    
    # Get the current sudoers file
    sudo cp /etc/sudoers "$TMP_SUDOERS"
    
    # Add the NOPASSWD entry for the current user
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | sudo tee -a "$TMP_SUDOERS" > /dev/null
    
    # Validate the syntax of the new sudoers file
    if sudo visudo -c -f "$TMP_SUDOERS"; then
        # If validation succeeded, install the new sudoers file
        sudo cp "$TMP_SUDOERS" /etc/sudoers
        echo "Passwordless sudo has been configured for $USERNAME"
    else
        echo "Error: The sudoers file failed validation. No changes were made."
        sudo rm -f "$TMP_SUDOERS"
        exit 1
    fi
fi

# Clean up
sudo rm -f "$TMP_SUDOERS"

echo "Configuration complete!"