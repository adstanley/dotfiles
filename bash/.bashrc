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
# Bashrc

# Declare associative array for function help
declare -A FUNCTION_HELP

## If not running interactively, don't do anything
# This prevents functions, aliases, and paths from being loaded 
# unnecessarily by non-interactive shells (like scripts or sftp sessions).
[[ $- != *i* ]] && return

#################################################################################
#                       Change to Modular Structure                             #
#################################################################################

# Modular configuration files - loaded in explicit order
declare -a modular_files=(
    "00-shell-opt.sh"         # Shell options (must be first)
    "01-xdg.sh"               # XDG base directories
    "02-colors.sh"            # Color definitions
    "03-terminal.sh"          # Terminal capabilities & key bindings
    "04-help.sh"              # Help functions
    "05-history.sh"           # History configuration (early because some tools read $HISTFILE)
    "06-path.sh"              # PATH modifications – critical, before any external tool
    "07-prompt.sh"            # Prompt (depends on colors + path)
    "08-bash-completion.sh"   # Bash completion (needs final $PATH)
    "09-bash-functions.sh"    # Your core custom functions
    "10-bash-aliases.sh"      # General aliases (often use the functions above)
    "11-git-aliases.sh"       # Git-specific aliases (depend on functions)
    "12-nvim.sh"              # Neovim-related settings/wrappers
    "13-find.sh"              # Enhanced find utilities
    "14-yt-dlp.sh"            # yt-dlp helpers
    "15-zfs.sh"               # ZFS tools (if applicable)
    "16-ssh.sh"               # SSH config / helpers
    "17-fzf.sh"               # fzf keybindings & completion (depends on PATH + functions)
    "18-mv.sh"                # Safe mv with backup, etc.
    "19-packs.sh"             # Package manager shortcuts
    "20-tmux.sh"              # tmux integration (usually fine at the end)
)

# Example of sourcing OS specific configurations
# [[ $(uname) == "Darwin" ]] && source macos-specific.sh
# [[ $(uname) == "Linux" ]] && modular_files+=("linux-specific.sh")
# [[ $(uname) == "WSL" ]] && modular_files+=("wsl-specific.sh")

# Debug
DEBUG="true"

# Path to your modular config directory
MODULAR_DIR="${HOME}/.github/dotfiles/bash"

# Source each modular file
# for file in "${modular_files[@]}"; do
#     full_path="${MODULAR_DIR}/${file}"
#     [[ -f "$full_path" ]] && source "$full_path" || echo "Warning: $full_path not found" >&2
# 	if [ "$DEBUG" == "true" ]; then
# 		printf "sourced %s\n" "$full_path"
# 	fi
# done
for file in "${modular_files[@]}"; do
    # Trim any accidental leading/trailing whitespace just in case
    file=$(echo "$file" | xargs)
    full_path="${MODULAR_DIR}/${file}"

    if [[ -r "$full_path" && -f "$full_path" ]]; then
        source "$full_path"
        [[ "$DEBUG" == "true" ]] && printf "sourced %s\n" "$full_path"
    else
        echo "Error: Cannot read regular file: '$full_path'" >&2
        # Optional: hex dump the path to see if there are weird characters
        if [[ "$DEBUG" == "true" ]]; then
             printf "Path Hex: %s\n" "$full_path" | xxd
        fi
    fi
done
unset file full_path

#################################################################################
#####                                ENV                                    #####
#################################################################################
## nvim as default editor
if command -v nvim >/dev/null 2>&1; then
	export EDITOR="nvim"
else
	export EDITOR="nano"
fi

#################################################################################
#####                            BATCAT/BAT                                 #####
#################################################################################
# Symlink batcat to bat since some distros use batcat instead of bat
if ! command -v "bat"; then
	if command -v "batcat"; then
		ln -s /usr/bin/batcat /usr/bin/bat
	fi
fi

# Figure out if bat or batcat is installed, if not fall back on cat
function get_bat_command()
{
	local commands=("batcat" "bat")
	for cmd in "${commands[@]}"; do
		if command -v "$cmd" >/dev/null 2>&1; then
			echo "$cmd"
			return 0
		fi
	done

	# fallback on cat
	echo "cat"
	# 'set filetype to man, - to read from stdin'
	# export MANPAGER="nvim -c 'set ft=man' -"
}

## "bat" as manpager
if command -v batcat >/dev/null 2>&1; then
	bat_command=$(get_bat_command)
	export MANPAGER=
else
	export MANPAGER="less"
fi

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

#################################################################################
#                                    Functions                                  #
#################################################################################

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



# navigation
#@begin_function up
function up()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	local d=""
	local limit="$1"

	# Default to limit of 1
	if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
		limit=1
	fi

	for ((i = 1; i <= limit; i++)); do
		d="../$d"
	done

	# perform cd. Show error if cd fails
	if ! cd "$d"; then
		echo "Couldn't go up $limit dirs."
	fi
}
#@end_function

#@begin_function printargs
function printargs()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	for ((i = 1; i <= $#; i++)); do
		printf "Arg %d: %s\n" "$i" "${!i}"
	done
}
#@end_function

# Define the function to show ZFS holds
#@begin_function holds
function holds()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	zfs get -Ht snapshot userrefs | grep -v $'\t'0 | cut -d $'\t' -f 1 | tr '\n' '\0' | xargs -0 zfs holds
}
#@end_function

# Function to create multiple ZFS datasets at once
#@begin_function create_datasets
function create_datasets()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	local pool_name="$1"
	shift # Remove the first argument (pool name)

	# Check if pool name was provided
	if [ -z "$pool_name" ]; then
		printf "Error: Pool name is required\n"
		printf "Usage: create_datasets <pool_name> <dataset1> <dataset2> ...\n"
		return 1
	fi

	# Check if at least one dataset name was provided
	if [ $# -eq 0 ]; then
		printf "Error: At least one dataset name is required\n"
		printf "Usage: create_datasets <pool_name> <dataset1> <dataset2> ...\n"
		return 1
	fi

	# Create each dataset
	for ds in "$@"; do
		printf "Creating dataset: %s\n" "$pool_name/$ds"
		zfs create "$pool_name/$ds" && printf "Success\n" || printf "Failed with exit code %s\n" "$?"
	done
}
#@end_function

#@begin_function deletesnapshot
function deletesnapshot()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# Check if the input is empty
	if [ -z "$1" ]; then
		printf "Input is empty\n" >&2
		return 1
	fi

	# List all snapshots for the given dataset
	zfs list -H -o name -t snapshot -r "$1"

	# Prompt the user to confirm the deletion
	read -pr "Delete all snapshots? (y/n) " answer

	# Check if the user confirms
	if [[ $answer =~ ^[Yy] ]]; then
		# Delete all snapshots for the dataset
		zfs list -H -o name -t snapshot -r "$1" | xargs -n1 zfs destroy
	else
		# Print "Aborting..." and exit the function
		printf "Aborting...\n"
	fi
}
#@end_function

#@ Name: takesnapshot
#@ Description: Create a ZFS snapshot for a specified dataset
#@ Arguments: <dataset> [snapshot_suffix]
#@ Usage: takesnapshot <dataset> [snapshot_suffix] [--dry-run]
#@ define help information
FUNCTION_HELP[takesnapshot]=$(
	cat <<'EOF'
NAME
    takesnapshot - Create a ZFS snapshot for a specified dataset
DESCRIPTION
    Create a ZFS snapshot for the specified dataset. If no snapshot suffix is provided, a default suffix of "manual-YYYY-MM-DD_HH-MM-SS" is used.
USAGE
    takesnapshot <dataset> [snapshot_suffix] [--dry-run]
OPTIONS
    <dataset>        : ZFS dataset name (e.g., poolname/dataset)
    [snapshot_suffix]: Optional custom suffix for snapshot name (default: manual-YYYY-MM-DD_HH-MM-SS)
    --dry-run        : Show the snapshot command without executing it
    --help           : Display this help message
EXAMPLES
    takesnapshot poolname/dataset
        Create a snapshot with the default suffix.
    takesnapshot poolname/dataset custom_suffix
        Create a snapshot with a custom suffix.
    takesnapshot --dry-run poolname/dataset
        Show the snapshot command without executing it.
EOF
)
#@begin_function takesnapshot
function takesnapshot_old()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# Check if the input is empty
	if [ -z "$1" ]; then
		printf "Input is empty\n" >&2
		return 1 # Exit with error
	fi

	# Check if the zfs command is available
	if ! command -v zfs &>/dev/null; then
		printf "Error: zfs command not found or not installed\n" >&2
		return 1 # Exit with error
	fi

	# Create a snapshot for the given dataset
	if output=$(zfs snapshot "$1@manual-$(date +"%Y-%m-%d_%H-%M-%S")" 2>&1); then
		printf "%s\n" "$output"
	else
		printf "Error: %s\n" "$output" >&2
		return 3 # Exit with error
	fi
}
#@end_function

#@ Name: takesnapshot
#@ Description: Create a ZFS snapshot for a specified dataset
#@ Arguments: <dataset> [snapshot_suffix]
#@ Usage: takesnapshot <dataset> [snapshot_suffix] [--dry-run]
#@ define help information
FUNCTION_HELP[takesnapshot]=$(
	cat <<'EOF'
NAME
    takesnapshot - Create a ZFS snapshot for a specified dataset
DESCRIPTION
    Create a ZFS snapshot for the specified dataset. If no snapshot suffix is provided, a default suffix of "manual-YYYY-MM-DD_HH-MM-SS" is used.
USAGE
    takesnapshot <dataset> [snapshot_suffix] [--dry-run]
OPTIONS
    <dataset>        : ZFS dataset name (e.g., poolname/dataset)
    [snapshot_suffix]: Optional custom suffix for snapshot name (default: manual-YYYY-MM-DD_HH-MM-SS)
    --dry-run        : Show the snapshot command without executing it
    --help           : Display this help message
EXAMPLES
    takesnapshot poolname/dataset
        Create a snapshot with the default suffix.
    takesnapshot poolname/dataset custom_suffix
        Create a snapshot with a custom suffix.
    takesnapshot --dry-run poolname/dataset
        Show the snapshot command without executing it.
EOF
)
#@begin_function takesnapshot
function takesnapshot()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# Check if zfs command is available
	if ! command -v zfs &>/dev/null; then
		printf "Error: zfs command not found or not installed\n" 1>&2
		return 1
	fi

	# Check if dataset is provided
	if [ -z "$1" ]; then
		printf "Error: No dataset specified\n" 1>&2
		return 2
	fi

	local dataset="$1"
	local snapshot_suffix="${2:-manual-$(date +"%Y-%m-%d_%H-%M-%S")}"
	local dry_run=false

	# Check for dry-run flag
	if [ "$dataset" = "--dry-run" ]; then
		if [ -z "$2" ]; then
			printf "Error: --dry-run requires a dataset\n" 1>&2
			return 2
		fi
		dry_run=true
		dataset="$2"
		snapshot_suffix="${3:-manual-$(date +"%Y-%m-%d_%H-%M-%S")}"
	fi

	# Validate dataset existence
	if ! zfs list "$dataset" &>/dev/null; then
		printf "Error: Dataset '%s' does not exist\n" "$dataset" 1>&2
		return 3
	fi

	# Validate snapshot suffix (if provided)
	if [ -n "$2" ] && [ "$2" != "--dry-run" ] && [[ ! "$snapshot_suffix" =~ ^[a-zA-Z0-9_-]+$ ]]; then
		printf "Error: Invalid snapshot suffix '%s'. Use alphanumeric characters, '_', or '-'\n" "$snapshot_suffix" 1>&2
		return 4
	fi

	local snapshot_name="$dataset@$snapshot_suffix"

	# Perform dry run if requested
	if [ "$dry_run" = true ]; then
		printf "Dry run: Would execute: zfs snapshot %s\n" "$snapshot_name"
		return 0
	fi

	# Create the snapshot
	if output=$(zfs snapshot "$snapshot_name" 2>&1); then
		printf "Snapshot created: %s\n" "$snapshot_name"
		return 0
	else
		printf "Error creating snapshot: %s\n" "$output" 1>&2
		return 6
	fi
}
#@end_function takesnapshot

#@Name: getsnapshot
#@Description: Get a list of snapshots for a given dataset
#@Arguments: <dataset>
#@Usage: getsnapshot <dataset>
#@define help information
FUNCTION_HELP[getsnapshot]=$(
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
#@begin_function getsnapshot
function getsnapshot()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# Check if the input is empty
	if [ -z "$1" ]; then
		printf "Input is empty\n" >&2
		return 1
	fi

	# Check if the zfs command is available
	if ! command -v zfs &>/dev/null; then
		printf "Error: zfs command not found or not installed\n" >&2
		return 1
	fi

	# Retrieve the list of snapshots for the given dataset
	if output=$(zfs list -H -o name -t snapshot -r "$1" 2>&1); then
		printf "%s\n" "$output"
	else
		printf "Error: %s\n" "$output" >&2
		return 3
	fi
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
#@begin_function getspace
function getspace()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# Check if the input is empty
	if [ -z "$1" ]; then
		printf "Input is empty\n" >&2
		return 1
	fi

	# Check if the zfs command is available
	if ! command -v zfs &>/dev/null; then
		printf "Error: zfs command not found or not installed\n" >&2
		return 1
	fi

	# Retrieve the list of snapshots for the given dataset
	# if output=$(zfs list -o space -t snapshot -r "$1" | sort -k3 --human-numeric-sort 2>&1); then
	if output=$(zfs list -H -o space -t snapshot -r "$1" | sort -k3 --human-numeric-sort 2>&1); then
		printf "%s\n" "$output"
	else
		printf "Error: %s\n" "$output" >&2
		return 3
	fi

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

#@Name: type
#@Description: Run type command and format output with bat
#@Arguments: function/alias/command
#@Usage: type nvim
#@define help information
FUNCTION_HELP[type]=$(
	cat <<'EOF'
NAME
    type - Show the type of a command
DESCRIPTION
    This function uses the `type` command to display the type of a command (alias, function, built-in, or executable).
USAGE
    type [COMMAND]
OPTIONS
    -h, --help
        Show this help message and exit.
EXAMPLES
    type ls
        Shows the type of the `ls` command.
EOF
)
function type()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	command type "$@" | bat -l sh
}

#################################################################################
#                               Installer Added                                 #
#################################################################################
