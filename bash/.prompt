#!/usr/bin/env bash

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

# Source bash-git-prompt if it exists
# if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
#     GIT_PROMPT_ONLY_IN_REPO=1
#     source "$HOME/.bash-git-prompt/gitprompt.sh"
# fi

# Only check once if git is available, then set a flag.
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

# Set Prompt
PS1="${debian_chroot:+(${debian_chroot})}${YELLOW}\u${RESET}@${GREEN}\h${RESET}:${BLUE}[\w]${RESET}\$(git_prompt) > ${RESET}"