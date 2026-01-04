#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        10-find.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines find functions for searching files and directories.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

# Declare associative array for function help
declare -A FUNCTION_HELP

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

#@Name: find_all
#@Description: Search for directories matching a pattern across multiple datasets based on hostname.
#@Arguments:
#  - <pattern>: The substring to search for in directory names.
#@Returns: Prints the paths of matching directories.
#@Usage: find_all <pattern>
#@define help information
FUNCTION_HELP[find_all]=$(
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
		find /mnt/toshiba /mnt/toshiba2 /mnt/toshiba3 /mnt/toshiba4 /mnt/toshiba5 /mnt/spool /mnt/spool-temp /mnt/mach2 /mnt/seagatemirror -not -path "*/Incomplete/*" -type d -iname "*$1*" -printf "%f\n" | sort
	elif [ "$HOSTNAME" == "truenas2" ]; then
		find /mnt/z2pool/Pr0n /mnt/z2pool/Pr0n.Datasets /mnt/zpool/Pr0n -type d -iname "*$1*" -printf "%f\n" | sort
	else
		echo "This function is only available on ix-truenas and truenas2"
		return 1
	fi
}
#@end_function

#@Name: find_shallow
#@Description: Search for directories matching a pattern across multiple datasets based on hostname.
#@Arguments:
#  - <pattern>: The substring to search for in directory names.
#@Returns: Prints the paths of matching directories.
#@Usage: find_shallow <pattern>
#@define help information
FUNCTION_HELP[find_shallow]=$(
	cat <<'EOF'
NAME
  find_shallow - Search for directories matching a pattern across multiple datasets based on hostname.
DESCRIPTION
  This function searches for directories whose names contain the specified pattern
  across multiple datasets, depending on the hostname of the machine.
USAGE
  find_shallow <pattern>
OPTIONS
  <pattern>   The substring to search for in directory names.
EXAMPLES
  find_shallow "movies"
	Searches for directories containing "movies" in their names across the predefined datasets.
EOF
)
#@begin_function find_shallow
function find_shallow() {
	# indirect help check
	handle_help "$@" && return 0

	if [ "$HOSTNAME" == "ix-truenas" ]; then
		find /mnt/toshiba/Pr0n.Datasets /mnt/toshiba2/SORTME /mnt/toshiba3/Pr0n.Datasets /mnt/toshiba4/SORTME /mnt/toshiba5/Pr0n.Datasets /mnt/mach2/Pr0n /mnt/seagatemirror/Pr0n.Datasets -not -path "*/Incomplete/*" -maxdepth 1 -type d -iname "*$1*"
	elif [ "$HOSTNAME" == "truenas2" ]; then
		find /mnt/z2pool/Pr0n /mnt/z2pool/Pr0n.Datasets /mnt/zpool/Pr0n -maxdepth 1 -type d -iname "*$1*"
	else
		echo "This function is only available on ix-truenas and truenas2"
		return 1
	fi
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

#@Name: catalog_dir
#@Description: Create a catalog of a directory's contents
#@Arguments: [directory] [output_file]
#@Usage: catalog_dir [directory] [output_file]
#@define help information
FUNCTION_HELP[catalog_dir]=$(
	cat <<'EOF'
NAME
    catalog_dir - Create a catalog of a directory's contents

DESCRIPTION
    This function creates a catalog of the contents of a directory, including a summary of file counts and sizes,
    a detailed listing of files, and a breakdown of file types.

USAGE
    catalog_dir [DIRECTORY] [OUTPUT_FILE]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
function catalog_dir()
{
	local dir="${1:-.}"
	local output="${2:-directory_catalog.txt}"

	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	{
		echo "Catalog of $dir created on $(date)"
		echo "----------------------------------------"

		# File count and total size
		echo "Summary:"
		find "$dir" -type f | wc -l | xargs echo "Total files:"
		du -sh "$dir" | awk '{print "Total size: " $1}'
		echo ""

		# Detailed listing with permissions, size, and date
		echo "Detailed listing:"
		/usr/bin/ls -lah "$dir"
		echo ""

		# File type breakdown
		echo "File types:"
		find "$dir" -type f | grep -v "^\." | sort | rev | cut -d. -f1 | rev | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr
	} >>"$output"

	echo "Catalog saved to $output"
}
#@end_function

#@Name: nested
#@Description: Find duplicate directory names in the current directory and its subdirectories
#@Arguments: None
#@Usage: nested
#@define help information
FUNCTION_HELP[nested]=$(
	cat <<'EOF'
NAME
    nested - Find duplicate directory names in the current directory and its subdirectories
DESCRIPTION
    Find duplicate directory names in the current directory and its subdirectories.
USAGE
    nested
OPTIONS
    None
EXAMPLES
    nested
        Find and list duplicate directory names in the current directory and its subdirectories.
EOF
)
#@begin_function
function nested()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# Simple version
	# find "$(pwd)" -type d | awk -F'/' '{print $NF}' | sort | uniq -cd

	find -- * -type d |
		awk -F '/' '{print $NF}' |
		sort |
		uniq -cd |
		while read -r count name; do
			printf "Duplicate directory name found: \n%s (%s times)\n" "$name" "$count"
			find -- * -type d -name "$name"
		done

}
#@end_function

#@Name: findext
#@Description: Find files with a specific extension in the current directory
#@Arguments: <extension>
#@Usage: findext <extension>
#@define help information
FUNCTION_HELP[findext]=$(
	cat <<'EOF'
NAME
    findext - Find files with a specific extension in the current directory
DESCRIPTION
    Find files with a specific extension in the current directory and its subdirectories.
USAGE
    findext <extension>
OPTIONS
    <extension> : The file extension to search for (e.g., .txt, .jpg)
EXAMPLES
    findext .txt
        Find all files with the .txt extension in the current directory and its subdirectories.
EOF
)
#@begin_function findext
function findext()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# Check if the input is empty
	if [ -z "$1" ]; then
		printf "Input is empty\n" >&2
		return 1
	fi

	# Find files with the specified extension
	find -- * -type f -name "*$1" -print0 | xargs -0 command ls -lh --color=always
}
#@end_function


#@Name: extensions
#@Description: List unique file extensions in the current directory
#@Arguments: None
#@Usage: extensions
#@define help information
FUNCTION_HELP[extensions]=$(
	cat <<'EOF'
NAME
	extensions - List unique file extensions in the current directory
DESCRIPTION
	List unique file extensions in the current directory and its subdirectories, along with their counts.
USAGE
	extensions
OPTIONS
	None
EXAMPLES
	extensions
		List all unique file extensions in the current directory and their counts.
EOF
)
#@begin_function extensions
function extensions()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# Check if the directory is empty
	if [ -d "$PWD" ]; then
		printf "Directory is empty\n" >&2
		return 1
	fi

	find -- * -type f | sed -e 's/.*\.//' | sed -e 's/.*\///' | sort | uniq -c | sort -rn
}
#@end_function
