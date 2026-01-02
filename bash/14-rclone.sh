#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        14-rclone.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines rclone functions.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

# Declare associative array for function help
declare -A FUNCTION_HELP

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
#@begin_function moveTemplate
function moveTemplate()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	local -a local="$1"
	for ((i = 0; i < "${#local[@]}"; i++)); do
		if [ -e "${local[$i]}" ]; then
			cp -pvi "${local[$i]}" ./incomplete/
			rm "${local[$i]}"
		else
			echo "Source file '${local[$i]}' does not exist."
		fi
	done
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
#@begin_function rclone_move
function rclone_move()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# Check if the input is empty
	if [ -z "$1" ]; then
		printf "Input is empty\n" >&2
		return 1
	fi

	# Check if the input is less than 2 arguments
	if [ $# -lt 2 ]; then
		printf "Error: Must have at least 2 arguments, but %d given.\n" "$#" >&2
		return 1
	fi

	# Check if the rclone command is available
	if ! command -v rclone &>/dev/null; then
		printf "Error: rclone command not found or not installed\n" >&2
		return 1 # Exit with error
	fi

	local src="$1"
	local dest="$2"
	shift 2 # Remove the first two arguments

	# Check if source exists
	if ! src=$(readlink -e "$src"); then
		printf "Error: Source \"%s\" doesn't exist or is not accessible.\n" "$1" >&2
		return 1
	fi

	local parent_dir
	parent_dir=$(dirname "$dest")

	# Check if parent directory of destination exists
	if [ ! -d "$parent_dir" ]; then
		printf "Parent directory of destination \"%s\" doesn't exist.\n" "$parent_dir"
		read -p "Do you want to create it? (y/n): " -n 1 -r
		echo # Move to a new line
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			mkdir -p "$parent_dir"
		else
			printf "Operation cancelled.\n"
			return 1
		fi
	fi

	# Execute the rclone command with the provided arguments
	if output=$(rclone move -P --delete-empty-src-dirs --ignore-existing --checkers 4 --transfers 4 --order-by size,mixed,75 "$src" "$dest" 2>&1); then
		printf "%s\n" "$output"
	else
		printf "Error: %s\n" "$output" >&2
		return 3 # Exit with error
	fi
}
#@end_function