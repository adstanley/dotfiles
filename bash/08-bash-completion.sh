#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        08-bash-completion.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines bash completion settings.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f "/usr/share/bash-completion/bash_completion" ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f "/etc/bash_completion" ]; then
		. /etc/bash_completion
	fi
fi

# Source custom completion scripts from .bash_completion.d
# if .bash_completion.d exists
if [ -d "${HOME}/.bash_completion" ]; then
	for file in "${HOME}"/.bash_completion/*; do
		if [ -f "$file" ]; then
			source "$file"
		fi
	done
fi

# Source VSCode shell integration if running inside VSCode terminal
[[ "$TERM_PROGRAM" == "vscode" ]] && source "$(code --locate-shell-integration-path bash)"
