#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        06-path.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines bash PATH settings.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

#################################################################################
#####                             Path                                      #####
#################################################################################

# Custom PATH additions
declare -a path_array=(
	"${HOME}/.bin"
	"${HOME}/.local/bin"
	"${HOME}/.appimage"
	"${HOME}/.applications"
	"${HOME}/.cargo/bin"
	"${HOME}/.local/share/fnm"
)

# Add to PATH
for directory in "${path_array[@]}"; do
	if [ -d "$directory" ]; then
		case ":$PATH:" in
		*":$directory:"*) ;;
		*) PATH="$directory:$PATH" ;;
		esac
	fi
done
unset directory

# De-duplicate PATH entries and export
PATH=$(echo "$PATH" | awk -v RS=: -v ORS=: '!a[$0]++')
PATH=${PATH%:}
export PATH

# DEBUG: Print each path entry on a new line
function print_path()
{
	IFS=':' read -ra paths <<<"$PATH"
	printf "%s\n" "${paths[@]}"
	unset paths
}