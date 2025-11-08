#!/usr/bin/env bash

# Setup git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.rebase true

# Name: git_shallow
# Description: Shallow clone a git repository
# Arguments: [clone] [url]
# Usage: git_shallow clone [url]
#@begin_function git_shallow
function git_shallow()
{
	handle_help "$@" && return 0

	if [ "$1" = "clone" ]; then
		shift 1
		command git clone --depth=1 "$@"
	else
		command git "$@"
	fi
}
#@end_function

# Name: git_branch
# Description: Shows current git branch
# Arguments: None
# Usage: git_branch
#@begin_function
function git_branch()
{
	handle_help "$@" && return 0

	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
#@end_function