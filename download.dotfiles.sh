#!/usr/bin/env bash
#===============================================================================#
#          ____ ___ ____ __  __    _    ____ _   _    _    ____                 #
#         / ___|_ _/ ___|  \/  |  / \  / ___| | | |  / \  |  _ \                #
#         \___ \| | |  _| |\/| | / _ \| |   | |_| | / _ \ | | | |               #
#          ___) | | |_| | |  | |/ ___ \ |___|  _  |/ ___ \| |_| |               #
#         |____/___\____|_|  |_/_/   \_\____|_| |_/_/   \_\____/                #
#                                                   Chet Manley                 #
#                                           http://sigmachad.io                 #
#                                   http://github.com/adstanley                 #
#===============================================================================#

#===============================================================================#
# Variables
#===============================================================================#

dotfiles_dir=~/dotfiles
log_file=~/install_progress_log.txt

## create logfile
if [ ! -f $log_file ]; then
    touch $log_file
fi

#===============================================================================#
# Move existing dot files and folders
#===============================================================================#

# check if gnu stow is installed
if ! command -v stow &> /dev/null; then
    printf "GNU Stow is not installed. Please install it first.\n"
    exit 1
fi


## create backup folder
if [ ! -d ~/.dotfiles_old ]; then
    mkdir -p ~/.dotfiles_old
fi

movefiles() {
    printf "\n====== Moving existing dot files ======\n"
    sudo mv -rf ~/.vim > /dev/null 2>&1
    sudo mv -rf ~/.vimrc > /dev/null 2>&1
    sudo mv -rf ~/.bashrc > /dev/null 2>&1
    sudo mv -rf ~/.tmux > /dev/null 2>&1
    sudo mv -rf ~/.tmux.conf > /dev/null 2>&1
    sudo mv -rf ~/.zsh_prompt > /dev/null 2>&1
    sudo mv -rf ~/.zshrc > /dev/null 2>&1
    sudo mv -rf ~/.gitconfig > /dev/null 2>&1
    sudo mv -rf ~/.antigen > /dev/null 2>&1
    sudo mv -rf ~/.antigen.zsh > /dev/null 2>&1
    sudo mv -rf ~/.psqlrc > /dev/null 2>&1
    sudo mv -rf ~/.tigrc > /dev/null 2>&1
    sudo mv -rf ~/.config > /dev/null 2>&1
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

ln -sf $dotfiles_dir/vim ~/.vim
ln -sf $dotfiles_dir/vimrc ~/.vimrc
ln -sf $dotfiles_dir/bashrc ~/.bashrc
ln -sf $dotfiles_dir/linux-tmux ~/.tmux
ln -sf $dotfiles_dir/config ~/.config


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