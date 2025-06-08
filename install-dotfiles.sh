#!/usr/bin/env bash
###########################################################
#  ____ ___ ____ __  __    _    ____ _   _    _    ____   #
# / ___|_ _/ ___|  \/  |  / \  / ___| | | |  / \  |  _ \  #
# \___ \| | |  _| |\/| | / _ \| |   | |_| | / _ \ | | | | #
#  ___) | | |_| | |  | |/ ___ \ |___|  _  |/ ___ \| |_| | #
# |____/___\____|_|  |_/_/   \_\____|_| |_/_/   \_\____/  #
#                                                         #
#    ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗     #
#    ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝     #
#    ██████╔╝███████║███████╗███████║██████╔╝██║          #
#    ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║          #
#    ██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗     #
#    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝     #
#                            http://github.com/adstanley  #
#                                    http://sigmachad.io  #
#                                            Chet Manley  #
###########################################################
#
# This script is designed to manage dotfiles in a user's home directory.
# Shellcheck Directvies
# shellcheck shell=bash
# shellcheck source=/dev/null
# shellcheck disable=SC1090
# shellcheck disable=SC1091
# shellcheck disable=SC2034
set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error
set -o pipefail  # Prevents errors in a pipeline from being masked

# Configuration
DOTFILES_DIR="$HOME/.github/dotfiles"
REPO_URL="https://github.com/adstanley/dotfiles.git"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# List of dotfiles to manage (expand this list for additional dotfiles)
DOTFILES=".bashrc"

# Ensure the dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles repository..."
    git clone "$REPO_URL" "$DOTFILES_DIR" || {
        echo "Error: Failed to clone repository."
        exit 1
    }
else
    echo "Updating dotfiles repository..."
    cd "$DOTFILES_DIR" || exit 1
    git pull || {
        echo "Error: Failed to update repository."
        exit 1
    }
fi

# Create backup directory
mkdir -p "$BACKUP_DIR" || {
    echo "Error: Failed to create backup directory."
    exit 1
}

# Process each dotfile
for file in $DOTFILES; do
    target="$HOME/$file"
    source="$DOTFILES_DIR/$file"

    # Backup existing file if it exists and is not a symlink
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up existing $file to $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/" || {
            echo "Error: Failed to backup $file."
            exit 1
        }
    fi

    # Remove existing symlink if it exists
    if [ -L "$target" ]; then
        rm "$target" || {
            echo "Error: Failed to remove existing symlink for $file."
            exit 1
        }
    fi

    # Create symlink
    if [ -f "$source" ]; then
        echo "Creating symlink for $file"
        ln -s "$source" "$target" || {
            echo "Error: Failed to create symlink for $file."
            exit 1
        }
    else
        echo "Warning: $file not found in dotfiles repository."
    fi
done

echo "Dotfiles installation complete. Backups stored in $BACKUP_DIR"