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
#
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
BACKUP_DIR="$HOME/.backup/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
REPO_URL="https://github.com/adstanley/dotfiles.git"

# List of dotfiles to manage (format: target_file:source_subdir)
# target_file is the file in $HOME, source_subdir is the folder in $DOTFILES_DIR
DOTFILES=".bashrc:bash .nanorc:nano .tmux.conf:tmux .nanorc:nano"

# Check if dotfiles directory exists, if not clone it
if [ ! -d "$DOTFILES_DIR" ]; then
    printf "Cloning dotfiles repository...\n"
    git clone "$REPO_URL" "$DOTFILES_DIR" || {
        echo "Error: Failed to clone repository."
        exit 1
    }
else
    # check if repo needs to be updated
    printf "Repository exists. Pulling repository...\n"
    cd "$DOTFILES_DIR" || exit 1
    git pull || {
        echo "Error: Failed to update repository."
        exit 1
    }
fi

# Create backup directory
if [ -d "$BACKUP_DIR" ]; then
    if [ "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
        printf "Error: Backup directory %s exists.\n" "'$BACKUP_DIR'"
        exit 1
    else
        echo "Using existing empty backup directory: $BACKUP_DIR"
    fi
elif ! mkdir -p "$BACKUP_DIR"; then
    echo "Error: Failed to create backup directory '$BACKUP_DIR'."
    exit 1
fi

# Function to restore backup if it exists
restore_backup() {
    local target_file="$1"
    local target="$2"
    
    if [ -f "$BACKUP_DIR/$target_file" ] && [ ! -L "$BACKUP_DIR/$target_file" ]; then
        echo "Restoring backup for $target_file"
        mv "$BACKUP_DIR/$target_file" "$target" || {
            echo "Error: Failed to restore backup for $target_file."
            exit 1
        }
    else
        echo "No valid backup found for $target_file, skipping restoration."
    fi
}

# Process each dotfile
for entry in $DOTFILES; do
    # Split entry into target_file and source_subdir
    target_file=$(echo "$entry" | cut -d':' -f1)
    source_subdir=$(echo "$entry" | cut -d':' -f2)

    target="$HOME/$target_file"
    source="$DOTFILES_DIR/$source_subdir/$target_file"

    # Backup existing file if it exists and is not a symlink
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up existing $target_file to $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/" || {
            echo "Error: Failed to backup $target_file."
            exit 1
        }
    fi

    # Remove existing symlink if it exists
    if [ -L "$target" ]; then
        rm "$target" || {
            echo "Error: Failed to remove existing symlink for $target_file."
            exit 1
        }
    fi

    # Create symlink
    if [ -f "$source" ]; then
        echo "Creating symlink for $target_file"
        ln -s "$source" "$target" || {
            echo "Error: Failed to create symlink for $target_file."
            restore_backup "$target_file" "$target"
            exit 1
        }
    else
        echo "Warning: $target_file not found in $source_subdir directory of dotfiles repository."
        restore_backup "$target_file" "$target"
    fi
done

echo "Dotfiles installation complete. Backups stored in $BACKUP_DIR"