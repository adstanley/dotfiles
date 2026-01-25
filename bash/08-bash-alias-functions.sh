#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        08-bash-alias-functions.sh
# AUTHOR:      Sigmachad
# DATE:        2026-01-23
# DESCRIPTION: Defines bash aliases and functions.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

#################################################################################
#####                            Aliases                                    #####
#################################################################################

# Some aliases are functions
# nvim is an alias to nvim.appimage if it exists

# Declare associative array for function help
declare -A FUNCTION_HELP

# Filesystem Shortcuts
#@Name: cd_drive
#@Description: Change directory to a specified drive
#@Arguments: [directory]
#@Usage: cd_drive [directory]
#@define help information
FUNCTION_HELP[cd_drive]=$(
	cat <<'EOF'
NAME
    cd_drive - Change directory to a specified drive

DESCRIPTION
    Change the current directory to a specified drive. If the directory does not exist, an error message is printed.

USAGE
    cd_drive [DIRECTORY]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function
function cd_drive() {

	local dir="$1"
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	if [[ -d "$dir" ]]; then
		cd "$dir" || {
			printf "Failed to change to %s\n" "$dir"
			return 1
		}
	else
		printf "Directory %s does not exist\n" "$dir"
		return 1
	fi
}
#@end_function

#@Name: makeAlias
#@Description: Create a bash alias from the last command in history
#@Arguments: <alias_name>
#@Usage: makeAlias <alias_name>
#@define help information
FUNCTION_HELP[makeAlias]=$(
	cat <<'EOF'
NAME
    makeAlias - Create a bash alias from the last command in history
DESCRIPTION
    Create a bash alias from the last command in history. The alias will be saved in ~/.bash_aliases.
USAGE
    makeAlias <alias_name>
OPTIONS
    <alias_name> : The name of the alias to create
EXAMPLES
    makeAlias myalias
        Create an alias named 'myalias' from the last command in history.
EOF
)
#@begin_function makeAlias
function makeAlias()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	if [ $# -eq 0 ]; then
		echo "No arguments supplied. You need to pass an alias name"
	else
		newAlias=$(history | tail -n 2 | cut -c 8- | sed -e '$ d')
		escapedNewAlias=${newAlias//\'/\'\\\'\'}
		echo "alias $1='${escapedNewAlias}'" >>~/.bash_aliases
		. ~/.bashrc
	fi
}
#@end_function