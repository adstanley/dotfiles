#!/usr/bin/env bash

# New Machine Setup Script

github_dir="$HOME/.github"

if [ ! -d "$github_dir" ]; then
    printf "Creating %s directory...\n" "$github_dir"
    mkdir -v "$github_dir"
fi

function home() {
  cd "$HOME" || exit
}

# Packages to install
InstallArray=(docker.io docker-buildx	build-essential pkg-config autoconf bison rustc cargo clang \
	libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libjemalloc2 \
	libvips imagemagick libmagickwand-dev mupdf mupdf-tools \
	redis-tools sqlite3 libsqlite3-0 libmysqlclient-dev \
	rbenv apache2-utils)

# Update apt and install packages
sudo apt update -y
sudo apt install -y "${InstallArray[@]}"


# CLI apps
sudo apt install -y git curl fzf ripgrep bat eza zoxide btop
sudo snap install code zellij --classic


# Install iA Writer theme for Typora
# cd ~/Downloads || exit
# git clone https://github.com/dhh/ia_typora
# mkdir -p ~/.local/share/fonts
# cp ia_typora/fonts/iAWriterMonoS-* ~/.local/share/fonts/
# fc-cache
# mkdir -p ~/snap/typora/88/.config/Typora/themes/
# cp ia_typora/ia_typora*.css ~/snap/typora/88/.config/Typora/themes/
# cd - || exit

# Ruby
# echo 'eval "$(/usr/bin/rbenv init - bash)"' >> "${HOME}/.bashrc"
# source "${HOME}/.bashrc"
# git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
# rbenv install 3.3.1
# rbenv global 3.3.1

# Binstubs
# cat << EOF >> "${HOME}/.bashrc"
# export PATH="./bin:$PATH"
# set +h
# alias r='./bin/rails'
# EOF

cat << EOF >> "${HOME}/.bashrc"
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
EOF

source "${HOME}/.bashrc"

# Setup bash
cat << EOF >> "${HOME}/.bashrc"
alias ls='eza -lh --group-directories-first --icons'
alias lt='eza --tree --level=2 --long --icons --git'
alias ff="fzf --preview 'batcat --style=numbers --color=always {}'" 
alias bat='batcat'
eval "$(zoxide init bash)"
EOF

source "${HOME}/.bashrc"

# Setup GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
gh auth login

# Setup Docker
echo "Add user to docker group (needs restart to become effective)"
sudo usermod -aG docker "${USER}"
echo "alias d='docker'" >> "${HOME}/.bashrc"
source "${HOME}/.bashrc"

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p "$DOCKER_CONFIG"/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 -o "$DOCKER_CONFIG/cli-plugins/docker-compose"
chmod +x "$DOCKER_CONFIG/cli-plugins/docker-compose"

docker run -d --restart unless-stopped -p 3306:3306 --name=mysql8 -e MYSQL_ROOT_PASSWORD= -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:8
docker run -d --restart unless-stopped -p 6379:6379 --name=redis redis

# Setup nodenv
git clone https://github.com/nodenv/nodenv.git ~/.nodenv
sudo ln -vs ~/.nodenv/bin/nodenv /usr/local/bin/nodenv
cd ~/.nodenv || exit
src/configure && make -C src

cd "${HOME}" || exit
mkdir -p "$(nodenv root)"/plugins
git clone https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build
git clone https://github.com/nodenv/nodenv-aliases.git "$(nodenv root)"/plugins/nodenv-aliases
nodenv install 20.11.1
nodenv global 20.11.1
sudo ln -vs "$(nodenv root)"/shims/* /usr/local/bin/
echo 'eval "$(nodenv init -)"' >> "${HOME}/.bashrc"
source "${HOME}/.bashrc"


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