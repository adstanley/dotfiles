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

dotfiles_dir=~/dotfiles
log_file=~/install_progress_log.txt

## create logfile
if [ ! -f $log_file ]; then
    touch $log_file
fi

#===============================================================================#
# Move existing dot files and folders
#===============================================================================#

function command_exists() {
    command -v "$1" > /dev/null 2>&1
}

# check if gnu stow is installed
if ! command_exists "stow"; then
    printf "GNU Stow is not installed. Please install it first.\n"
    exit 1
fi


## create backup folder
if [ ! -d ~/.dotfiles_old ]; then
    mkdir -p ~/.dotfiles_old
fi

move_dot_files() {
    local dot_files=(
        ".vim"
        ".vimrc"
        ".bashrc"
        ".tmux"
        ".tmux.conf"
        ".zsh_prompt"
        ".zshrc"
        ".gitconfig"
        ".antigen"
        ".antigen.zsh"
        ".psqlrc"
        ".tigrc"
        ".config"
    )

    printf "\n====== Moving existing dot files ======\n"

    for ((i = 0; i < ${#dot_files[@]}; i++)); do
        sudo mv -rf ~/"${dot_files[$i]}" > /dev/null 2>&1
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
        ".zsh_prompt"
        ".zshrc"
        ".gitconfig"
        ".antigen"
        ".antigen.zsh"
        ".psqlrc"
        ".tigrc"
        ".config"
    )

    printf "\n====== Creating symlinks ======\n"

    for file in "${dot_files[@]}"; do
        ln -sf $dotfiles_dir/"$file" ~/"$file"
    done


}

if [ -n "$(find $dotfiles_dir/custom-configs -name gitconfig)" ]; then
    ln -s $dotfiles_dir/custom-configs/**/gitconfig ~/.gitconfig
else
    ln -s $dotfiles_dir/gitconfig ~/.gitconfig
fi

if [ -n "$(find $dotfiles_dir/custom-configs -name tmux.conf)" ]; then
    ln -s $dotfiles_dir/custom-configs/**/tmux.conf ~/.tmux.conf
else
    ln -s $dotfiles_dir/linux-tmux/tmux.conf ~/.tmux.conf
fi

if [ -n "$(find $dotfiles_dir/custom-configs -name tigrc)" ]; then
    ln -s $dotfiles_dir/custom-configs/**/tigrc ~/.tigrc
else
    ln -s $dotfiles_dir/tigrc ~/.tigrc
fi

if [ -n "$(find $dotfiles_dir/custom-configs -name psqlrc)" ]; then
    ln -s $dotfiles_dir/custom-configs/**/psqlrc ~/.psqlrc
else
    ln -s $dotfiles_dir/psqlrc ~/.psqlrc
fi


#===============================================================================#
# Give the user a summary of what has been installed                            #
#===============================================================================#

printf "\n====== Summary ======\n"
cat $log_file
printf
printf "DONE\n"
rm $log_file