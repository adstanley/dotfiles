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
# Bashrc
# Shellcheck Directvies
# shellcheck shell=bash
# shellcheck source=/dev/null
# shellcheck disable=SC1090
# shellcheck disable=SC1091
# shellcheck disable=SC2034

# define cleanup function
cleanup() {
    local exit_code=$?
    echo "Script is exiting with code: $exit_code"
    
    # You can use the exit code for conditional actions
    if [ $exit_code -ne 0 ]; then
        echo "An error occurred during execution"
        # Additional error-specific cleanup
    fi
    
    # If you want to explicitly exit with the same code
    exit $exit_code
}

# Set the trap to call cleanup on EXIT signal
trap cleanup EXIT # Ensure cleanup is called on exit

# check if gnu stow is installed
if ! command -v "stow" > /dev/null 2>&1; then
    printf "GNU Stow is not installed. Please install it first.\n"
    exit 1
fi

dot_files=(
    # ".vim"
    # ".vimrc"
    ".bashrc"
    # ".bash_profile"
    # ".bash_functions"
    # ".bash_aliases"
    # ".bash_logout"
    # ".bash_prompt"
    # ".bash_completion"
    # ".tmux"
    # ".tmux.conf"
    # ".zsh_prompt"
    # ".zshrc"
    # ".gitconfig"
)

logging=true
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"

homedir="${HOME}"
if [ -z "$homedir" ]; then
    printf "Error: HOME environment variable is not set.\n"
    exit 1
fi

dotfiles_dir="$HOME/dotfiles"
dotfiles_backup_dir="$HOME/dotfiles_backup"
log_dir="$HOME/logs"
log_file="$log_dir/dotfiles_log.txt"

if [ "$logging" = true ] && [ ! -f "$log_file" ]; then
    touch "$log_file"
fi

if [ ! -d "$dotfiles_backup_dir" ]; then  
    if ! mkdir -p "$dotfiles_backup_dir"; then
        printf "Error: Could not create backup directory %s\n" "$dotfiles_backup_dir"
        exit 1
    fi
    printf "Backup directory created: %s\n" "$dotfiles_backup_dir"
else
    printf "Backup directory already exists: %s\n" "$dotfiles_backup_dir"
fi

# Match and remove regex element from array
#@begin_function
function remove_element() {
    local regexPattern=$1
    local -a array

    # make array a copy of the array whose name is passed as an arg
    eval array=\( \"\$\{"$1"\[@\]\}\" \)

    for ((i = 0; i < ${#array[@]}; i++)); do
        if [[ ${array[$i]} =~ $regexPattern ]]; then
            unset "${array[$i]}"
        fi
    done
}
#@end_function

move_dot_files() {
    local dot_files=(
        ".vim"
        ".vimrc"
        ".bashrc"
        ".tmux"
        ".tmux.conf"
    )

    printf "\n====== Moving existing dot files ======\n"

    for ((i = 0; i < ${#dot_files[@]}; i++)); do
        mv --no-clobber --verbose ~/"${dot_files[$i]}" ~/"${dot_files[$i]}"_"$(date +"%Y-%m-%d_%H-%M-%S")".bk
    done
}

## move existing dotfiles to backup folder

while true; do
    read -pr "Do you want to move existing dotfiles to ~/dotfiles_old? (y/n) : " yn
    case $yn in
    [Yy]*)
        movefiles
        break
        ;;
    [Nn]*) exit ;;
    *) printf "Please answer yes or no." ;;
    esac
done

#===============================================================================#
# Create symlinks in the home folder
# Allow overriding with files of matching names in the custom-configs dir
#===============================================================================#
link_dotfiles() {
    local dot_files=(
        ".vim"
        ".vimrc"
        ".bashrc"
        ".tmux"
        ".tmux.conf"
    )

    printf "\n====== Creating symlinks ======\n"

    for file in "${dot_files[@]}"; do
        ln -sf "$dotfiles_dir"/"$file" ~/"$file"
    done


}

if [ -n "$(find "$dotfiles_dir" -iname ".bashrc")" ]; then
    ln -s "$dotfiles_dir"/.bashrc /.bashrc
else
    ln -s "$dotfiles_dir"/gitconfig ~/.gitconfig
fi


# if [ -n "$(find "$dotfiles_dir"/custom-configs -name gitconfig)" ]; then
#     ln -s "$dotfiles_dir"/custom-configs/**/gitconfig ~/.gitconfig
# else
#     ln -s "$dotfiles_dir"/gitconfig ~/.gitconfig
# fi

# if [ -n "$(find "$dotfiles_dir"/custom-configs -name tmux.conf)" ]; then
#     ln -s "$dotfiles_dir"/custom-configs/**/tmux.conf ~/.tmux.conf
# else
#     ln -s "$dotfiles_dir"/linux-tmux/tmux.conf ~/.tmux.conf
# fi

# if [ -n "$(find "$dotfiles_dir"/custom-configs -name tigrc)" ]; then
#     ln -s "$dotfiles_dir"/custom-configs/**/tigrc ~/.tigrc
# else
#     ln -s "$dotfiles_dir"/tigrc ~/.tigrc
# fi

# if [ -n "$(find "$dotfiles_dir"/custom-configs -name psqlrc)" ]; then
#     ln -s "$dotfiles_dir"/custom-configs/**/psqlrc ~/.psqlrc
# else
#     ln -s "$dotfiles_dir"/psqlrc ~/.psqlrc
# fi


#===============================================================================#
# Give the user a summary of what has been installed                            #
#===============================================================================#

printf "\n====== Summary ======\n"
cat "$log_file"
printf
printf "DONE\n"
rm "$log_file"