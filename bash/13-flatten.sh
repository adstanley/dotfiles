#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        13-flatten.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines ACL functions for managing access control lists.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

# Declare associative array for function help
declare -A FUNCTION_HELP

#@Name: flatten
#@Description: flatten subdirectories by moving all files to the current directory
#@Arguments: None
#@Usage: flatten
#@define help information
FUNCTION_HELP[flatten]=$(
	cat <<'EOF'
NAME
    flatten - Move all files from subdirectories to the current directory

DESCRIPTION
    Move all files from subdirectories to the current directory, avoiding duplicates.

USAGE
    function_name [OPTIONS]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function
function flatten()
{
	local -a flatten
	local -a duplicates
	local current_dir
	current_dir=$(pwd)

	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	readarray -t subdirs < <(find "$current_dir" -type d ! -path "$current_dir")
	if [ "${#subdirs[@]}" -eq 0 ]; then
		printf "No subdirectories found.\n" >&2
		return 1
	else
		printf "Found %s subdirectories:\n" "${#subdirs[@]}"
		printf "%s\n" "${subdirs[@]}"
	fi

	readarray -t flatten < <(find "$current_dir" -type f)
	if [ "${#flatten[@]}" -eq 0 ]; then
		printf "No files found in subdirectories.\n" >&2
		return 1
	else
		printf "%s\n" "${flatten[@]}"
		printf "\nFound %s files in %s subdirectories.\n" "${#flatten[@]}" "$(find "$current_dir" -type d | wc -l)"
	fi

	read -rp "This will move all files in subdirectories to the current directory. Continue? (Y\N) : " answer
	if [[ ! $answer =~ ^[Yy] ]]; then
		printf "Aborting...\n" >&2
		return 1
	fi
	for ((i = 0; i < "${#flatten[@]}"; i++)); do
		if ! mv --no-clobber --verbose "${flatten[$i]}" "$current_dir" 2>/dev/null; then
			duplicates+=("${flatten[$i]}")
		fi
	done

	if [ "${#duplicates[@]}" -gt 0 ]; then
		printf "\nThe following files were not moved due to duplicates:\n"
		printf "%s\n" "${duplicates[@]}"
	fi
}
#@end_function

#@Name: remove_empty_dirs
#@Description: Remove empty directories in the specified directory
#@Arguments: None
#@Usage: remove_empty_dirs
#@define help information
FUNCTION_HELP[remove_empty_dirs]=$(
	cat <<'EOF'
NAME
    remove_empty_dirs - Remove empty directories in the specified directory

DESCRIPTION
    Remove empty directories in the specified directory, prompting for confirmation before deletion.

USAGE
    function_name [OPTIONS]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function
function remove_empty_dirs()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	local current_dir
	current_dir=$(pwd)

	target_dir="${1:-$current_dir}"

	if [[ ! -d "$target_dir" ]]; then
		echo "Error: '$target_dir' is not a directory or does not exist." >&2
		exit 1
	fi

	target_dir=$(realpath "$target_dir")

	case "$target_dir" in
	/ | /boot | /home | /root | /etc | /var | /usr | /bin | /sbin | /lib | /lib64 | /dev | /proc | /sys | /tmp | /opt | /srv | /media | /mnt)
		echo "Error: Refusing to operate in critical directory '$target_dir'." >&2
		exit 1
		;;
	esac

	echo "Scanning for empty directories in: $target_dir"

	find "$target_dir" -type d -empty -print0 | while IFS= read -r -d '' dir; do
		echo "Found empty directory: $dir"
		read -rp "Delete this directory? [y/N] " answer
		if [[ "$answer" =~ ^[Yy]$ ]]; then
			if rmdir "$dir" 2>/dev/null; then
				echo "Deleted: $dir"
			else
				echo "Failed to delete: $dir (possibly not empty or permission denied)" >&2
			fi
		else
			echo "Skipped: $dir"
		fi
	done

	printf "Done.\n"
}
#@end_function

#@Name: example
#@Description: example function
#@Arguments: None
#@Usage: example
#@define help information
FUNCTION_HELP[example]=$(
	cat <<'EOF'
NAME
    function_name - Short description of the function

DESCRIPTION
    A longer description of the function, explaining what it does and how to use it.

USAGE
    function_name [OPTIONS]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function insertDirectory
function insertDirectory()
{

	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	local filename insert
	filename="$(realpath "$1")" || return 1
	insert="$2"

	# Check if file exists
	if [ ! -e "$filename" ]; then
		printf "File '%s' does not exist.\n" "$filename" >&2
		return 1
	fi

	# Check if insert is a directory
	if [ ! -d "$PWD/$insert" ]; then
		read -rp "Directory '$insert' does not exist. Create Directory? (Y\N) " answer
		if [[ $answer =~ ^[Yy] ]]; then
			mkdir -pv "$insert" || return 1
		else
			printf "Aborting...\n"
			return 1
		fi
	fi

	# Preview change
	printf "Preview: \nMoving:\n%s\nto:\n%s/%s/%s\n\n" "$filename" "$(dirname "$1")" "$insert" "$(basename "$1")"

	# Prompt for confirmation
	read -rp "Continue? (Y\N) " answer
	if [[ $answer =~ ^[Yy] ]]; then
		mv -iv "$filename" "$(dirname "$1")/$insert/$(basename "$1")"
		return 0
	else
		printf "Aborting...\n"
	fi
}
#@end_function
