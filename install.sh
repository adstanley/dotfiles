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
# TODO: Change entire script to use gnu stow
set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error
set -o pipefail  # Prevents errors in a pipeline from being masked

# Configuration
TEMP="$HOME/tmp"

# Dotfiles Directory
DOTFILES_DIR="$HOME/.github/dotfiles"

# Dotfiles backup directory
BACKUP_DIR="$HOME/.backup/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Dotfiles repo url
REPO_URL="https://github.com/adstanley/dotfiles.git"

# List of dotfiles to manage (format: target_file:source_subdir)
# target_file is the file in $HOME, source_subdir is the folder in $DOTFILES_DIR
#DOTFILES=".bashrc:bash .nanorc:nano .tmux.conf:tmux .nanorc:nano"

# Check if repo exists locally, if not clone it
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

# Define the associative array
declare -A DOTFILES_ARRAY
DOTFILES_ARRAY=(
    [".bashrc"]="bash"
    [".nanorc"]="nano"
    [".tmux.conf"]="tmux"
    [".vimrc"]="vim"
    [".gitconfig"]="git"
    [".zshrc"]="zsh"
)

declare -A FOLDERS
FOLDERS=(
    ["bash_completion"]="bash_completion"
    ["nvim"]="{$HOME}/.config/nvim"
)

# Reversion Function
restore_backup() {
    local target_file="$1"
    local target="$2"
    
    if [ -f "$BACKUP_DIR/$target_file" ] && [ ! -L "$BACKUP_DIR/$target_file" ]; then
        printf "Restoring backup for %s.\n" "$target_file"
        mv "$BACKUP_DIR/$target_file" "$target" || {
            printf "Error: Failed to restore backup for %s.\n" "$target_file"
            exit 1
        }
    else
        printf "No valid backup found for %s, skipping restoration.\n" "$target_file"
    fi
}

# Make backup directory if it doesn't exist and ensure it's empty
if [ "$(find "$BACKUP_DIR" -mindepth 1 -print -quit 2>/dev/null)" ]; then
    printf "Error: Backup directory %s exists and is not empty.\n" "'$BACKUP_DIR'"
    exit 1
fi
mkdir -p "$BACKUP_DIR" || {
    printf "Error: Failed to create backup directory: '%s'\n" "$BACKUP_DIR"
    exit 1
}

# Process each dotfile in the array
for target_file in "${!DOTFILES_ARRAY[@]}"; do

    # Target file is Key
    target="$HOME/$target_file"

    # Source subdir is value
    source_subdir="${DOTFILES_ARRAY[$target_file]}"

    # Construct source path
    source="$DOTFILES_DIR/$source_subdir/$target_file"

    # Backup existing file if it exists and is not a symlink
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        printf "Backing up existing %s to %s/\n" "$target_file" "$BACKUP_DIR"
        mv -v "$target" "$BACKUP_DIR/" || {
            printf "Error: Failed to backup %s.\n" "$target_file"
            exit 1
        }

        # Change backup file name to include hostname
        mv "$BACKUP_DIR/$target_file" "$BACKUP_DIR/$(hostname)_$target_file"
    fi

    # Remove existing symlink if it exists
    if [ -L "$target" ]; then
        rm -v "$target" || {
            printf "Error: Failed to remove existing symlink for %s.\n" "$target_file"
            exit 1
        }
    fi

    # Create symlink
    if [ -f "$source" ]; then
        printf "Creating symlink for %s\n" "$target_file"
        ln -s "$source" "$target" || {
            printf "Error: Failed to create symlink for %s.\n" "$target_file"
            restore_backup "$target_file" "$target"
            exit 1
        }
    else
        printf "Warning: %s not found in %s directory of dotfiles repository.\n" "$target_file" "$source_subdir"
        restore_backup "$target_file" "$target"
    fi
done

printf "Dotfiles installation complete. Backups stored in %s\n" "$BACKUP_DIR"

# Process each folder in the array
# for folder_name in "${!FOLDERS[@]}"; do
#     target_folder="${FOLDERS[$folder_name]}"
#     source_folder="$DOTFILES_DIR/$folder_name"

#     # Create symlink for the folder
#     if [ -d "$source_folder" ]; then
#         printf "Creating symlink for %s\n" "$target_folder"
#         ln -s "$source_folder" "$target_folder" || {
#             printf "Error: Failed to create symlink for %s.\n" "$target_folder"
#             exit 1
#         }
#     else
#         printf "Warning: %s not found in dotfiles repository.\n" "$source_folder"
#     fi
# done