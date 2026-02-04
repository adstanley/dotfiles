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

#################################################################################
#                                    Functions                                  #
#################################################################################

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
#@begin_function
function example()
{
	######################################################################
	# Pick One
	######################################################################

	# Direct help check
	if [[ "$1" == "--help" || "$1" == "-h" ]]; then
		if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
			echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
		else
			echo "Help not available for function: ${FUNCNAME[0]}" >&2
			return 2
		fi
		return 0
	fi
	######################################################################

	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	######################################################################

	# Example function code here
	echo "This is an example function."

	######################################################################
}
#@end_function

#@Name: up
#@Description: Change directory up N levels
#@Arguments: N (number of levels to go up)
#@Usage: up 2
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
up_nematron() {
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

    local n=${1:-1}
    local target
    
	# 
	(( n < 1 )) && return 0
	
    # build target path
	target=$(printf '%*s' "$n" '' | tr ' ' '../')
    
	# strip trailing slash
	target=${target%/}
    
	# Try to change directory
	if ! cd -- "$target"; then
        printf 'Could not cd up %s dir(s).\n' "$n" >&2
        return 1
    fi
}


#@begin_function printargs
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
function printargs()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# Declare local variable
	local i
	
	# Loop through all arguments and print them
	for ((i = 1; i <= $#; i++)); do
		printf "Arg %d: %s\n" "$i" "${!i}"
	done

	# unset local variable
	unset i
}
#@end_function

#@begin_function printargs
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
function printarray() {
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# Declare local variable
    local -n _arr=$1

	# Loop through all elements in the array and print them
	# Have to inlcude -- before text or printf tries to parse 
	# "--- Array" as an option
    printf -- "--- Array Contents (Size: %d) ---\n" "${#_arr[@]}"
    
	for i in "${!_arr[@]}"; do
        printf "Key: %d\t\t Value: %s\n" "$i" "${_arr[$i]}"
    done
}
#@end_function

#@Name: reset_cursor
#@Description: Reset cursor to blinking bar
#@Arguments: None
#@Usage: reset_cursor
#@define help information
FUNCTION_HELP[reset_cursor]=$(
	cat <<'EOF'
NAME
    reset_cursor - Reset cursor to blinking bar
DESCRIPTION
    Reset the cursor to a blinking bar.
USAGE
    reset_cursor
EOF
)
function reset_cursor() {

	handle_help "${FUNCNAME[0]}" "$@" && return 0
	
    # Reset cursor position to blinking bar
    echo -ne "\e[6 q"
}
#@end_function

#@Name: countfields
#@Description: Count the number of fields in a directory name
#@Arguments: [directory]
#@Usage: countfields [directory]
#@define help information
FUNCTION_HELP[countfields]=$(
	cat <<'EOF'
NAME
    countfields - Count the number of fields in a directory name
DESCRIPTION
    Count the number of fields in a directory name, separated by dots.
    This is useful for identifying the number of fields in a directory name.
USAGE
    countfields [DIRECTORY]
EXAMPLES
    countfields /path/to/directory
    countfields .
    countfields *
EOF
)
#@begin_function countfields
function countfields()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	# if $1 is empty, use "*"
	local target_dir="${1:-*}"

	find -- "$target_dir" -maxdepth 0 -type d | awk -F"." '{print NF, $0}' | sort -nr | uniq -c
}
#@end_function

#@name cdir
#@description cd into the last files directory
#@usage cdir
#@example cdir
#@define help information
FUNCTION_HELP[cdir]=$(
	cat <<'EOF'
NAME
    cdir - change directory to the last file's directory
DESCRIPTION
    Change the current directory to the directory of the last file used in the command line.
USAGE
    cdir
EXAMPLES
    cdir
EOF
)
#@begin_function
function cdir()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	cd "${_%/*}" || return
}
#@end_function

# Function to backup file by appending .bk to the end of the file name
#@begin_function bk
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
function bk()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	cp "$1" "$1_$(date +"%Y-%m-%d_%H-%M-%S")".bk
}
#@end_function

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
function bk_nematron() 
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

    [[ -e $1 ]] || { echo "File not found: $1" >&2; return 1; }

    cp -- "$1" "${1}_$(date +%F_%T).bk"
}


# Function to convert hex to Asciic
#@begin_function hexToAscii
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
function hexToAscii()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	printf "\x%s" "$1"
}
#@end_function

# idk man
#@begin_function c2f
function c2f()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	fc -lrn | head -1 >>"${1?}"
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
#@begin_function type
function type()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	command type "$@" | bat -l sh
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
	if output=$(zfs list -H -o space -t snapshot -r "$1" | sort -k3 --human-numeric-sort 2>&1); then
		printf "%s\n" "$output"
	else
		printf "Error: %s\n" "$output" >&2
		return 3
	fi

}
#@end_function
