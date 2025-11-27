#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        10-find.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines find functions for searching files and directories.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

#@Name: find_all
#@Description: Search for directories matching a pattern across multiple datasets based on hostname.
#@Arguments:
#  - <pattern>: The substring to search for in directory names.
#@Returns: Prints the paths of matching directories.
#@Usage: find_all <pattern>
#@define help information
FUNCTION_HELP["find_all"]=$(
	cat <<'EOF'
NAME
  find_all - Search for directories matching a pattern across multiple datasets based on hostname.
DESCRIPTION
  This function searches for directories whose names contain the specified pattern
  across multiple datasets, depending on the hostname of the machine.
USAGE
  find_all <pattern>
OPTIONS
  <pattern>   The substring to search for in directory names.
EXAMPLES
  find_all "movies"
	Searches for directories containing "movies" in their names across the predefined datasets.
EOF
)
#@begin_function find_all
function find_all() {
	# indirect help check
	handle_help "$@" && return 0

	if [ "$HOSTNAME" == "ix-truenas" ]; then
		find /mnt/toshiba /mnt/toshiba2 /mnt/toshiba3 /mnt/toshiba4 /mnt/toshiba5 /mnt/spool /mnt/spool-temp /mnt/mach2 /mnt/seagatemirror -not -path "*/Incomplete/*" -type d -iname "*$1*"
	elif [ "$HOSTNAME" == "truenas2" ]; then
		find /mnt/z2pool/Pr0n /mnt/z2pool/Pr0n.Datasets /mnt/zpool/Pr0n -type d -iname "*$1*"
	else
		echo "This function is only available on ix-truenas and truenas2"
		return 1
	fi
}
#@end_function

#@begin_function find_dir
function find_dir() {
	# indirect help check
	handle_help "$@" && return 0

	printf "Searching for *%s*. \n" "$1"
	find -- * -iname "*$1*" -type d
}
#@end_function

#@begin_function find_file
function find_file() {
	# indirect help check
	handle_help "$@" && return 0

	printf "Searching for *%s*. \n" "$1"
	find -- * -iname "*$1*" -type f
}
#@end_function

# Function to find largest files in the current directory
#@begin_function find_largest_files
function find_largest_files() {
	# indirect help check
	handle_help "$@" && return 0

	du -h -x -s -- * | sort -r -h | head -20
}
#@end_function

# check if folder is empty
#@begin_function is_folder_empty
function is_folder_empty() {
	# indirect help check
	handle_help "$@" && return 0

	local folder_path="$1"

	if find "$folder_path" -maxdepth 0 -empty -exec test -d {} \; -quit; then
		echo "Folder '$folder_path' is **empty**."
	else
		# We specifically check for the folder's existence before declaring it not empty
		if [ -d "$folder_path" ]; then
			echo "Folder '$folder_path' is **not empty**."
		else
			echo "Error: Folder '$folder_path' does **not exist**."
		fi
	fi
}
#@end_function