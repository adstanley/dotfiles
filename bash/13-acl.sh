#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        13-acl.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines ACL functions for managing access control lists.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

# Declare associative array for function help
declare -A FUNCTION_HELP

#@Name: ownroot
#@Description: Change ownership to root
#@Usage: ownroot [directory]
#@define help information
FUNCTION_HELP[ownroot]=$(
	cat <<'EOF'
NAME
    ownroot - Change ownership to root
USAGE
    ownroot [DIRECTORY]
EXAMPLES
    ownroot /path/to/directory
    ownroot .
EOF
)
#@begin_function ownroot
function ownroot()
{

	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# "${1:-.}" = if $1 is empty, use current dir "."
	local target_dir="${1:-.}"
	target_dir=$(readlink -f "$target_dir")

	# Check if the target directory exists
	if [ ! -d "$target_dir" ]; then
		printf "Error: %s is not a directory.\n" "$target_dir" >&2
		return 1
	fi

	# Prevent modification of critical directories or their subdirectories
	if [[ "$target_dir" == /* || "$target_dir" == /home/* || "$target_dir" == /root/* || "$target_dir" == /etc/* ]]; then
		echo "Error: '$target_dir' is a critical system directory or subdirectory." >&2
		return 1
	fi

	# Sanity Check
	read -rp "Are you sure you want to change ownership of '$target_dir' to root? [y/N] " confirm

	if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
		echo "Operation cancelled."
		return 1
	fi

	# Change ownership recursively
	chown -R -v root:root "$target_dir"

	# Set directories to 755
	find "$target_dir" -type d -exec chmod -v 755 {} \;

	# Set folders to 644 idk grok suggested this revisit in future this is stupid anyway
	find "$target_dir" -type f -exec chmod -v 644 {} \;
}
#@end_function

#@Name: mod775
#@Description: modify permissions to 775, will default to current directory
#@Arguments: [directory]
#@Usage: mod775 ./
#@define help information
FUNCTION_HELP[mod775]=$(
	cat <<'EOF'
NAME
    example - This is an example function
USAGE
    dupebyname [DIRECTORY]
EXAMPLES
    dupebyname /path/to/directory
    dupebyname .
    dupebyname *
EOF
)
#@begin_function mod775
function mod775()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# "${1:-.}" = if $1 is empty, use "."
	local target_dir="${1:-.}"

	# Check if the target directory exists
	if [ ! -d "$target_dir" ]; then
		printf "Error: %s is not a directory.\n" "$target_dir" >&2
		return 1
	fi

	# Change ownership recursively
	chmod -R -v 775 "$target_dir"
}
#@end_function

#@Name: copyacl
#@Description: Copy ACLs from source directory to destination directory
#@Arguments: [source] [destination]
#@Usage: copyacl [source] [destination]
#@define help information
FUNCTION_HELP[copyacl]=$(
	cat <<'EOF'
NAME
    copyacl - Copy ACLs from source directory to destination directory

DESCRIPTION
    This function copies the Access Control Lists (ACLs) from a source directory to a destination directory.
    It ensures that the destination is not a critical system directory and that the source is readable.

USAGE
    Usage: copyacl [OPTIONS] [SOURCE] [DESTINATION]
    If SOURCE is not provided, it defaults to /mnt/spool/SABnzbd/.
    If DESTINATION is not provided, it defaults to the current working directory.

OPTIONS
    -h, --help			   Show this help message and exit.
	-s, --source=PATH      Source directory (default: /mnt/spool/SABnzbd/)
  	-d, --dest=PATH        Destination directory (default: current directory)

EXAMPLES
  copyacl
  copyacl -d /path/to/target
  copyacl /other/source /my/target
  copyacl --source=/src --dest=/dst

EOF
)
#@begin_function
function copyacl()
{
	# Defaults
	local source="/mnt/spool/SABnzbd/"
	local destination
	destination="$(pwd)"

	# Reset getopts in case it was used before
	unset OPTIND
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-h | --help)
			# Indirect help check
			handle_help "${FUNCNAME[0]}" "$@" && return 0
			;;
		-s | --source)
			[[ -z "$2" ]] && echo "Error: --source requires an argument" >&2 && return 1
			source="$2"
			shift 2
			;;
		--source=*)
			source="${1#*=}"
			shift
			;;
		-d | --dest)
			[[ -z "$2" ]] && echo "Error: --dest requires an argument" >&2 && return 1
			destination="$2"
			shift 2
			;;
		--dest=*)
			destination="${1#*=}"
			shift
			;;
		-s*) # Handle -s/path (combined short option)
			source="${1#-s}"
			[[ -z "$source" ]] && {
				echo "Error: -s requires an argument" >&2
				return 1
			}
			shift
			;;
		-d*)
			destination="${1#-d}"
			[[ -z "$destination" ]] && {
				echo "Error: -d requires an argument" >&2
				return 1
			}
			shift
			;;
		*) # Positional arguments (only if not already set via flags)
			if [[ "$source" == "/mnt/spool/SABnzbd/" && "$destination" == "$(pwd)" ]]; then
				# First positional = source, second = dest
				if [[ -n "$1" && -n "$2" ]]; then
					source="$1"
					destination="$2"
					shift 2
				elif [[ -n "$1" ]]; then
					# Only one positional → treat as destination (common pattern)
					destination="$1"
					shift
				fi
			else
				echo "Error: Unexpected positional argument: $1" >&2
				echo "$USAGE" >&2
				return 1
			fi
			;;
		esac
	done

	# Final fallback: if only destination was given positionally and source is still default
	# (this allows: copyacl /my/target   → uses default source, sets new dest)

	# Resolve absolute path
	destination=$(readlink -f "$destination") || return 1

	# Safety check - prevent damage to system dirs
	case "$destination" in
	/ | /boot | /home | /root | /etc | /var | /var/log | /usr | /bin | /sbin | /lib | /lib64 | /dev | /proc | /sys | /tmp | /opt | /srv | /media | /mnt)
		echo "Error: Refusing to modify ACLs in critical system directory '$destination'" >&2
		return 1
		;;
	esac

	# Validate source exists and is readable
	if [[ ! -d "$source" ]]; then
		echo "Error: Source directory '$source' does not exist" >&2
		return 1
	fi
	if [[ ! -r "$source" ]]; then
		echo "Error: Source directory '$source' is not readable" >&2
		return 1
	fi

	# Validate destination
	if [[ ! -d "$destination" ]]; then
		echo "Error: Destination '$destination' is not a directory" >&2
		return 1
	fi

	echo "Copying ACLs from '$source' to '$destination'..."

	# Actually copy the ACLs
	if getfacl -R -p "$source" | setfacl -R --set-file=- "$destination"; then
		echo "ACLs copied successfully from '$source' to '$destination'"
		return 0
	else
		echo "Failed to copy ACLs" >&2
		return 1
	fi
}
#@end_function