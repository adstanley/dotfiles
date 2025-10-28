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

# Install Neovim
cd "$github_dir" || printf "Failed to change directory to %s\n" "$github_dir" && exit 1
git clone https://github.com/neovim/neovim.git
git pull --tags
NEOVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') # get stable tag

# Install NvChad
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

# Install lazygit
# cd ~/Downloads || exit
# LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
# curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
# tar xf lazygit.tar.gz lazygit
# sudo install lazygit /usr/local/bin
# cd - || exit

# Install lazydocker
cd "${HOME}/Downloads" || exit
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
tar xf lazydocker.tar.gz lazydocker
sudo install lazydocker /usr/local/bin
cd - || exit

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