#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        09-ls.sh
# AUTHOR:      Sigmachad
# DATE:        2026-1-21
# DESCRIPTION: Defines environment variables.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

# Declare associative array for function help
declare -A FUNCTION_HELP

#################################################################################
#####                             LS/EXA                                    #####
#################################################################################

#@Name: get_ls_command
#@Description: Get preferred ls command (eza, exa, or ls)
#@Usage: get_ls_command
#@define help information
function get_ls_command()
{
	local commands=("eza" "exa")
	for cmd in "${commands[@]}"; do
		if command -v "$cmd" >/dev/null 2>&1; then
			echo "$cmd"
			return 0
		fi
	done

	# fallback on ls
	echo "ls"
}

LS_COMMAND=$(get_ls_command)
export LS_COMMAND

#@name ls_old
#@description Determine if eza or ls should be used
#@usage ls_old
#@define help information
FUNCTION_HELP[ls_old]=$(
	cat <<'EOF'
NAME
    ls - list directory contents

DESCRIPTION
    List information about files and directories, using eza if available.

USAGE
    ls [OPTIONS] [FILE]...

OPTIONS
    Same options as eza or ls depending on which is available.
    Add --help or -h to see this help message.

EXAMPLES
    ls -la ~/Documents
EOF
)
#@begin_function
function ls_old()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	if [ "$LS_COMMAND" = "eza" ]; then
		eza --all --long --header --git --icons --group-directories-first --color=always "$@"
	elif [ "$LS_COMMAND" = "exa" ]; then
		exa --all --long --header --git --icons --group-directories-first --color=always "$@"
	elif [ "$LS_COMMAND" = "ls" ]; then
		command ls -lahg --color=always --group-directories-first "$@"
	fi
}
#@end_function

FUNCTION_HELP[ls]=$(
	cat <<'EOF'
NAME
    ls - Enhanced directory listing with fallback support

DESCRIPTION
    A smart wrapper around eza, exa, or native ls. Uses $LS_COMMAND to decide
    which tool to use. Provides consistent formatting with icons, git status,
    and color.

USAGE
    ls [options] [path]

OPTIONS
    --help, -h
        Show this help message
    All other options are passed to the underlying command (eza/exa/ls)

EXAMPLES
    ls
        List current directory with enhanced view
    ls -l
        Pass -l to underlying tool
    ls --help
        Show this message

CONFIGURATION
    Set LS_COMMAND=eza  (or exa, ls) to control behavior
EOF
)
#@begin_function
function ls()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	local cmd
	case "$LS_COMMAND" in
	eza)
		cmd="eza --all --long --header --git --icons --group-directories-first --color=always"
		;;
	exa)
		cmd="exa --all --long --header --git --icons --group-directories-first --color=always"
		;;
	ls | "")
		cmd="command ls -lahg --color=always --group-directories-first"
		;;
	*)
		echo "Unknown LS_COMMAND: $LS_COMMAND, falling back to ls" >&2
		cmd="command ls -lahg --color=always --group-directories-first"
		;;
	esac

	eval "$cmd \"\$@\""
}
#@end_function

FUNCTION_HELP[ls]=$(
	cat <<'EOF'
NAME
    ls - Enhanced directory listing with fallback support

DESCRIPTION
    A smart wrapper around eza, exa, or native ls. Uses $LS_COMMAND to decide
    which tool to use. Provides consistent formatting with icons, git status,
    and color.

USAGE
    ls [options] [path]

OPTIONS
    --help, -h
        Show this help message
    All other options are passed to the underlying command (eza/exa/ls)

EXAMPLES
    ls
        List current directory with enhanced view
    ls -l
        Pass -l to underlying tool
    ls --help
        Show this message

CONFIGURATION
    Set LS_COMMAND=eza  (or exa, ls) to control behavior
EOF
)
function ls_nematron() {
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

    if command -v eza >/dev/null; then
        eza --all --long --header --git --icons --group-directories-first --color=always "$@"
    elif command -v exa >/dev/null; then
        exa --all --long --header --git --icons --group-directories-first --color=always "$@"
    else
        command ls -lahg --color=always --group-directories-first "$@"
    fi
}
#@end_function
