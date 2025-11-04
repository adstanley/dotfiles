#!/usr/bin/env bash

# Install ulauncher
sudo add-apt-repository universe -y
sudo add-apt-repository ppa:agornostal/ulauncher -y
sudo apt update
sudo apt install ulauncher

# GUI apps
sudo apt install xournalpp nautilus-dropbox alacritty
sudo snap install 1password spotify vlc zoom-client signal-desktop typora pinta

# Gnome tweaking
sudo apt install -y gnome-tweak-tool gnome-shell-extension-manager
echo "Use Tweak Tool to set Fonts > Size > Scaling Factor: 0.80"
echo "Use Extension Manager to install: Tactile, Blur my Shell, Just Perfection"

# Install chrome
cd ~/Downloads || exit
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
home

# Install Cascadia Nerd Font
cd ~/Downloads || exit
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaMono.zip
unzip CascadiaMono.zip -d CascadiaFont
mkdir -p ~/.local/share/fonts
cp CascadiaFont/*.ttf ~/.local/share/fonts
fc-cache
home

# Configure zellij for Tokyo Night theme
mkdir -p ~/.config/zellij
cat << EOF >> ~/.config/zellij/config.kdl
themes {
    tokyo-night {
        fg 169 177 214
        bg 26 27 38
        black 56 62 90
        red 249 51 87
        green 158 206 106
        yellow 224 175 104
        blue 122 162 247
        magenta 187 154 247
        cyan 42 195 222
        white 192 202 245
        orange 255 158 100
    }
}

theme "tokyo-night"
default_layout "compact"
EOF

# Configure alacritty for Tokyo Night theme
mkdir -p ~/.config/alacritty
cat << EOF >> ~/.config/alacritty/alacritty.toml
[env]
TERM = "xterm-256color"

[window]
padding.x = 16
padding.y = 14
decorations = "none"

[font]
normal = { family = "CaskaydiaMono Nerd Font", style = "Regular" }
size = 9

[keyboard]
bindings = [
{ key = "F11", action = "ToggleFullscreen" }
]

[colors]
[colors.primary]
background = '#1a1b26'
foreground = '#a9b1d6'

# Normal colors
[colors.normal]
black = '#32344a'
red = '#f7768e'
green = '#9ece6a'
yellow = '#e0af68'
blue = '#7aa2f7'
magenta = '#ad8ee6'
cyan = '#449dab'
white = '#787c99'

# Bright colors
[colors.bright]
black = '#444b6a'
red = '#ff7a93'
green = '#b9f27c'
yellow = '#ff9e64'
blue = '#7da6ff'
magenta = '#bb9af7'
cyan = '#0db9d7'
white = '#acb0d0'

[colors.selection]
background = '#7aa2f7'
EOF