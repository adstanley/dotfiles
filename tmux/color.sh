#!/bin/bash
# Based on: https://gist.github.com/XVilka/8346728

awk -v term_cols="${width:-$(tput cols || echo 80)}" 'BEGIN{
    s="/\\";
    for (colnum = 0; colnum<term_cols; colnum++) {
        r = 255-(colnum*255/term_cols);
        g = (colnum*510/term_cols);
        b = (colnum*255/term_cols);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum%2+1,1);
    }
    printf "\n";
}'


sudo apt update && sudo apt upgrade -y
sudo apt install git neovim tmux zsh curl wget ripgrep fd-find net-tools -y
sudo apt autoremove -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git config --global core.editor "nvim"
mkdir -p ~/.config
ssh-keygen
cat ~/.ssh/id_rsa.pub
git clone git@gitlab.com:sultanahamer/dotfiles.git ~/.config
ln -s ~/.config/.tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#.tmux.conf file
# better prefix key
set -g prefix C-s
bind C-s send-prefix
# better splitting
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# 256 colors support
set -g default-terminal "xterm-256color"
# set -ga terminal-overrides 'xterm*:Tc,alacritty,alacritty-direct,*-256col*:Tc,xterm-256col*:Tc'
# sane scrolling
set -g mouse on
# vi is good
setw -g mode-keys vi

# list of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'jimeh/tmux-themepack'



set -g @continuum-restore 'on' # starts the old sessions
set -g @powerline-status-right-area-middle-bg black
set -g @powerline-status-right-area-middle-fg colour39
set -g @powerline-status-right-area-left-bg green
set -g @powerline-status-right-area-left-fg black
set -g @themepack 'powerline/double/cyan'

# TMUX plugin manager (keep at the bottom of tmux.conf)
run -b '~/.tmux/plugins/tpm/tpm'
