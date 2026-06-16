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

# Configuration
GITHUB_DIR="$HOME/.github"
DOTFILES_DIR="$GITHUB_DIR/dotfiles"
REPO_URL="https://github.com/adstanley/dotfiles.git"
BACKUP_DIR="$HOME/.backup/dotfiles_backup-$(date +%Y%m%d_%H%M%S)"

# All git repos are stored in .github for convenience.
# if .github does not exist on a new machine, create it.
# If something goes sideways exit.
if [ ! -d "$GITHUB_DIR" ]; then
    printf "Github directory does not exist.\n"
    if mkdir -v "$HOME/.github"; then
        printf "Created github directory.\n"
    else
        printf "Could not create github directory, Exiting.\n"
        exit 1
    fi
fi

# Clone or update local copy of dotfiles repository
if [ ! -d "$DOTFILES_DIR/.git" ]; then
    printf "Cloning dotfiles repository...\n"
    git clone "$REPO_URL" "$DOTFILES_DIR" || {
        printf "Error: Failed to clone repository.\n"
        exit 1
    }
else
    printf "Valid Git repository detected. Pulling latest changes...\n"
    git -C "$DOTFILES_DIR" pull || {
        printf "Error: Failed to update repository.\n"
        exit 1
    }
fi

# 2. Pre-Stow Safety Backup
# Define all target paths that could conflict with Stow symlinks
TARGETS_TO_BACKUP=(
    "$HOME/.bashrc"
    "$HOME/.gitconfig"
    "$HOME/.nanorc"
    "$HOME/.tmux.conf"
    "$HOME/.vimrc"
    "$HOME/.zshrc"
    "$HOME/updatedb.conf"
    "$HOME/.config/nvim"
)

BACKUP_CREATED=false

for target in "${TARGETS_TO_BACKUP[@]}"; do
    # Only back up if the target exists and is not a symlink
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        if [ "$BACKUP_CREATED" = false ]; then
            mkdir -p "$BACKUP_DIR"
            BACKUP_CREATED=true
        fi

        item_name=$(basename "$target")
        backup_name="$(hostname)_${item_name}"

        printf "Backing up existing %s to %s/%s\n" "$item_name" "$BACKUP_DIR" "$backup_name"
        mv "$target" "$BACKUP_DIR/$backup_name" || {
            printf "Error: Failed to back up %s\n" "$item_name"
            exit 1
        }
    fi
done

if [ "$BACKUP_CREATED" = true ]; then
    printf "Backups successfully stored in: %s\n" "$BACKUP_DIR"
fi

# 3. GNU Stow Execution
printf "Stowing dotfiles...\n"
cd "$DOTFILES_DIR" || exit

# Define the directory packages inside your repo that you want to stow
PACKAGES=(bash git nano tmux updatedb vim zsh nvim)

# Filter out any packages that don't actually exist as directories in your repo yet
VALID_PACKAGES=()
for pkg in "${PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
        VALID_PACKAGES+=("$pkg")
    fi
done

if [ ${#VALID_PACKAGES[@]} -gt 0 ]; then
    # Stow targets the home directory (~), creating parent dirs like .config automatically
    stow --dotfiles -t ~ "${VALID_PACKAGES[@]}"
    printf "Dotfiles installation and stowing complete!\n"
else
    printf "Warning: No valid Stow directories found in %s. Check your repo structure.\n" "$DOTFILES_DIR"
fi
