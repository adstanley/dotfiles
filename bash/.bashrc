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

# Example of sourcing OS specific configurations
# [[ $(uname) == "Darwin" ]] && source macos-specific.sh
# [[ $(uname) == "Linux" ]] && modular_files+=("linux-specific.sh")
# [[ $(uname) == "WSL" ]] && modular_files+=("wsl-specific.sh")

# Debug
DEBUG="true"

# Path to your modular config directory
MODULAR_DIR="${HOME}/.github/dotfiles/bash"

# Force standard byte-order sorting for this loop
LC_COLLATE=C
# Source each modular file
for full_path in "${MODULAR_DIR}"/*.sh; do
    if [[ -r "$full_path" ]]; then
        source "$full_path"
        [[ "$DEBUG" == "true" ]] && printf "sourced %s\n" "$full_path"
    else
        echo "Warning: Cannot read $full_path" >&2
    fi
done
unset full_path

#################################################################################
#####                                ENV                                    #####
#################################################################################
## nvim as default editor
if command -v nvim > /dev/null 2>&1; then
	export EDITOR="nvim"
else
	export EDITOR="nano"
fi

#################################################################################
#####                            BATCAT/BAT                                 #####
#################################################################################
# Symlink batcat to bat since some distros use batcat instead of bat
if ! command -v "bat" > /dev/null 2>&1; then
	if command -v "batcat" > /dev/null 2>&1; then
		ln -s /usr/bin/batcat /usr/bin/bat
	fi
fi

# Figure out if bat or batcat is installed, if not fall back on cat
function get_bat_command()
{
	local commands=("batcat" "bat")
	for cmd in "${commands[@]}"; do
		if command -v "$cmd" > /dev/null 2>&1; then
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
function get_ls_command() {
    # Send logs to stderr so they don't interfere with the variable capture
    printf "Searching for preferred ls command...\n" >&2
    
    local commands=("eza" "exa" "ls")
    
    for cmd in "${commands[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            printf "%s" "$cmd" # "Return" the string
            return 0           # Signal success
        fi
    done

    return 1 # Signal that nothing was found
}

# Capture the stdout of the function
# Check if the function actually succeeded
if LS_COMMAND=$(get_ls_command); then
    export LS_COMMAND
    printf "Using: %s\n" "$LS_COMMAND" >&2
else
    printf "No ls command found!" >&2
fi

#################################################################################
#                                    Functions                                  #
#################################################################################

#@Name: up
#@Description: Change directory up N levels
#@Arguments: N (number of levels to go up)
#@Usage: up 2
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
	local i
	
	for ((i = 1; i <= $#; i++)); do
		printf "Arg %d: %s\n" "$i" "${!i}"
	done
}
#@end_function

#@begin_function printargs
function printarray() {
    local -n _arr=$1
    echo "--- Array Contents (Size: ${#_arr[@]}) ---"
    for i in "${!_arr[@]}"; do
        printf "[%d]: %s\n" "$i" "${_arr[$i]}"
    done
}
#@end_function

#@Name: getspace
#@Description: Get space usage of ZFS snapshots for a given dataset
#@Arguments: None
#@Usage: getspace <dataset>
#@define help information
FUNCTION_HELP[getspace]=$(
	cat <<'EOF'
NAME
    getspace - Get space usage of ZFS snapshots for a given dataset

DESCRIPTION
    This function retrieves and displays the space usage of ZFS snapshots for the specified dataset.

USAGE
    getspace <DATASET>

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES
	getspace poolname/dataset
		Retrieve and display space usage for snapshots of the specified dataset.

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
