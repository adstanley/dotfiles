#!/usr/bin/env bash
# lint_all.sh
dir="$HOME/.github/dotfiles/bash"

readarray -t modular_files < <(find "$dir" -type f -iname "*.sh")
for file in "${modular_files[@]}"; do
    shellcheck --shell=bash "${HOME}/.github/dotfiles/bash/$file"
done

shellcheck --shell=bash "${HOME}/.github/dotfiles/bash/.bashrc"
