#!/usr/bin/env bash
###########################################################
#                                                         #
#    ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗     #
#    ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝     #
#    ██████╔╝███████║███████╗███████║██████╔╝██║          #
#    ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║          #
#    ██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗     #
#    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝     #
#                            http://github.com/adstanley  #
#                                    http://sigmachad.io  #
#                                            Chet Manley  #
###########################################################
# Bashrc Functions
#
# Declare associative array for function help
declare -A FUNCTION_HELP

# Name: mv_check
# Description: Function for checking syntax of mv command
# Arguments: [source] [destination]
# Usage: mv_check [source] [destination]
#@begin_function mv_check
function mv_check()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# check if -t flag is present as this modifies the number of arguments we expect
	if [ "$1" = "-t" ]; then
		if [ $# -lt 3 ]; then
			printf "<<< ERROR: with -t flag, must have at least 3 arguments, but %s given\n" "$#" >&2
			return 1
		fi

		target_dir="$2"
		shift 2

		# check if target directory exists
		if [ ! -d "$target_dir" ]; then
			printf "<<< ERROR: target directory %s doesn't exist\n" "$target_dir" >&2
			return 1
		fi

		for src in "$@"; do
			if ! readlink -e "$src" >/dev/null; then
				printf "<<< ERROR: %s doesn't exist\n" "$src" >&2
				return 1
			fi
			printf "Moving %s into %s directory\n" "$src" "$target_dir"
		done

		# Execute the move command with -t flag
		mv -t "$target_dir" "$@"
		return $?

	else
		# check number of arguments
		if [ $# -ne 2 ]; then
			printf "<<< ERROR: must have 2 arguments, but %d given\n" "$#" >&2
			return 1
		fi

		src="$1"
		dest="$2"

		# check source
		if ! readlink -e "$src" >/dev/null; then
			printf "<<< ERROR: %s doesn't exist\n" "$src" >&2
			return 1
		fi

		# check destination
		if [ -d "$dest" ]; then
			printf "Moving %s into %s directory\n" "$src" "$dest"
		else
			printf "Renaming %s to %s\n" "$src" "$dest"
		fi

		# Execute the move command
		mv "$src" "$dest"
		return $?
	fi
}

# Name: rclonemove
# Description: Move files using rclone
# Arguments: [source] [destination]
# Usage: rclonemove [source] [destination]
#@begin_function rclonemove
function rclonemove()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# Check number of arguments
	if [ $# -ne 2 ]; then
		printf "<<< ERROR: Must have 2 arguments, but %d given.\n" "$#" >&2
		return 1
	fi

	# Check if source exists
	local source
	if ! source=$(readlink -e "$1"); then
		printf "<<< ERROR: Source \"%s\" doesn't exist or is not accessible.\n" "$1" >&2
		return 1
	fi

	local destination="$2"
	local parent_dir
	parent_dir=$(dirname "$destination")

	# Check if parent directory of destination exists
	if [ ! -d "$parent_dir" ]; then
		printf "Parent directory of destination \"%s\" doesn't exist.\n" "$parent_dir"
		read -p "Do you want to create it? (y/n): " -n 1 -r

		# Move to a new line
		echo
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			mkdir -p "$parent_dir"
		else
			printf "Operation cancelled.\n"
			return 1
		fi
	fi

	printf "Moving \"%s\" to \"%s\".\n" "$source" "$destination"
	rclone move -P --ignore-existing --checkers 4 --transfers 4 --order-by size,mixed,75 "$source" "$destination"
}
#@end_function

# Copy Function
#@begin_function rclonecopy
function rclonecopy()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# Check number of arguments
	if [ $# -ne 2 ]; then
		printf "<<< ERROR: Must have 2 arguments, but %d given.\n" "$#" >&2
		return 1
	fi

	# Check if source exists
	local source
	if ! source=$(readlink -e "$1"); then
		printf "<<< ERROR: Source \"%s\" doesn't exist or is not accessible.\n" "$1" >&2
		return 1
	fi

	local destination="$2"
	local parent_dir
	parent_dir=$(dirname "$destination")

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

	printf "Copying \"%s\" to \"%s\".\n" "$source" "$destination"
	rclone copy -P --ignore-existing --transfers 4 --order-by size,mixed,75 "$source" "$destination"
}
#@end_function