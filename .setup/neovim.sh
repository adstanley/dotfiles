#!/usr/bin/env bash

# Install Neovim
cd "$github_dir" || printf "Failed to change directory to %s\n" "$github_dir" && exit 1
git clone https://github.com/neovim/neovim.git
git pull --tags
NEOVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') # get stable tag

# Install NvChad
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1