#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        15-prompt.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines bash prompt settings.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

# Declare associative array for function help
declare -A FUNCTION_HELP

#################################################################################
#####                          PROMPT                                       #####
#################################################################################

# PS1    The  value  of  this parameter is expanded (see PROMPTING below)
#        and used as the primary prompt string.   The  default  value  is
#        ``\s-\v\$ ''.
# PS2    The  value of this parameter is expanded as with PS1 and used as
#        the secondary prompt string.  The default is ``> ''.
# PS3    The value of this parameter is used as the prompt for the select
#        command (see SHELL GRAMMAR above).
# PS4    The  value  of  this  parameter  is expanded as with PS1 and the
#        value is printed before each command  bash  displays  during  an
#        execution  trace.  The first character of PS4 is replicated mul‐
#        tiple times, as necessary, to indicate multiple levels of  indi‐
#        rection.  The default is ``+ ''.
#
# Reference: https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html

# Check if git is installed
if command -v git >/dev/null 2>&1; then
	__GIT_AVAILABLE=1
else
	__GIT_AVAILABLE=0
fi

function git_prompt() {
	local COLOR_GIT_CLEAN=$'\033[0;32m'    # Green for clean status
	local COLOR_GIT_STAGED=$'\033[0;33m'   # Yellow for staged changes
	local COLOR_GIT_MODIFIED=$'\033[0;31m' # Red for unstaged/untracked changes
	local COLOR_RESET=$'\033[0m'           # Reset color

	# Check if git is installed
	if ! command -v git >/dev/null 2>&1; then
		return
	fi

	# Check if in a git repository
	if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		return
	fi

	# Try to get tag name first
	local ref
	ref=$(git describe --tags --exact-match 2>/dev/null)

	# If no tag, get branch name
	if [ -z "$ref" ]; then
		ref=$(git symbolic-ref -q HEAD 2>/dev/null)
		ref=${ref##refs/heads/}
		ref=${ref:-HEAD}
	fi

	# If no branch, get commit hash
	if [ "$ref" = "HEAD" ]; then
		ref=$(git rev-parse --short HEAD 2>/dev/null)
	fi

	# If no commit hash, set ref to "unknown"
	if [ -z "$ref" ]; then
		ref="unknown"
	fi

	# Check git status
	local status_output
	status_output=$(git status 2>/dev/null)

	# If status is clean, show green
	if [[ $status_output = *"nothing to commit"* ]]; then
		printf " %s[%s]%s" "${COLOR_GIT_CLEAN}" "${ref}" "${COLOR_RESET}"
	# If there are staged changes, show yellow
	elif [[ $status_output = *"Changes to be committed"* ]]; then
		printf " %s[%s*]%s" "${COLOR_GIT_STAGED}" "${ref}" "${COLOR_RESET}"
	# If there are unstaged changes or untracked files, show red
	else
		printf " %s[%s*]%s" "${COLOR_GIT_MODIFIED}" "${ref}" "${COLOR_RESET}"
	fi
}

# Path to your modular config directory
BASH_GIT_PROMPT="${HOME}/.github/dotfiles/bash-git-prompt"

if [ -f "${BASH_GIT_PROMPT}/gitprompt.sh" ]; then

	# Configuration settings for bash-git-prompt
    GIT_PROMPT_ONLY_IN_REPO=1
	# GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status
	# GIT_PROMPT_IGNORE_SUBMODULES=1 # uncomment to avoid searching for changed files in submodules
	# GIT_PROMPT_WITH_VIRTUAL_ENV=0 # uncomment to avoid setting virtual environment infos for node/python/conda environments
	# GIT_PROMPT_VIRTUAL_ENV_AFTER_PROMPT=1 # uncomment to place virtual environment infos between prompt and git status (instead of left to the prompt)

	# GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch
	# GIT_PROMPT_SHOW_UNTRACKED_FILES=normal # can be no, normal or all; determines counting of untracked files

	# GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0 # uncomment to avoid printing the number of changed files

	# GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh # uncomment to support Git older than 1.7.10

	# GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
	# GIT_PROMPT_END=...      # uncomment for custom prompt end sequence

	# as last entry source the gitprompt script
	# GIT_PROMPT_THEME=Custom # use custom theme specified in file GIT_PROMPT_THEME_FILE (default ~/.git-prompt-colors.sh)
	# GIT_PROMPT_THEME_FILE=Single_line_Dark
	GIT_PROMPT_THEME=Single_line_Ubuntu # use one of the bundled themes

	# source the gitprompt script
    if source "${BASH_GIT_PROMPT}/gitprompt.sh"; then

		printf "sourced %s\n" "${BASH_GIT_PROMPT}/gitprompt.sh"

	else
		echo "Warning: Cannot read ${BASH_GIT_PROMPT}/gitprompt.sh" >&2
		
		# Set ghetto Git prompt
		PS1="${debian_chroot:+(${debian_chroot})}${YELLOW}\u${RESET}@${GREEN}\h${RESET}:${BLUE}[\w]${RESET}\$(git_prompt) > ${RESET}"
	fi

else
	echo "Warning: ${BASH_GIT_PROMPT}/gitprompt.sh not found" >&2
	# No Git

fi

# Stil set basic prompt because we only use git prompt if in a git repo
PS1="${debian_chroot:+(${debian_chroot})}${YELLOW}\u${RESET}@${GREEN}\h${RESET}:${BLUE}[\w]${RESET} > ${RESET}"