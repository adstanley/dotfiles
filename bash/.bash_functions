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
    # Reset cursor position to blinking bar
    echo -ne "\e[6 q"
}
#@end_function

alias bathelp='bat --plain --language=help'

help()
{
	"$@" --help 2>&1 | bathelp
}

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

#@name ls_old
#@description Determine if eza or ls should be used
#@usage ls_old
#@define help information
FUNCTION_HELP[ls_old]=$(
	cat <<'EOF'
NAME
    ls - list directory contents

DESCRIPTION
    List information about files and directories, using eza if available.

USAGE
    ls [OPTIONS] [FILE]...

OPTIONS
    Same options as eza or ls depending on which is available.
    Add --help or -h to see this help message.

EXAMPLES
    ls -la ~/Documents
EOF
)
#@begin_function
function ls_old()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	if [ "$LS_COMMAND" = "eza" ]; then
		eza --all --long --header --git --icons --group-directories-first --color=always "$@"
	elif [ "$LS_COMMAND" = "exa" ]; then
		exa --all --long --header --git --icons --group-directories-first --color=always "$@"
	elif [ "$LS_COMMAND" = "ls" ]; then
		command ls -lahg --color=always --group-directories-first "$@"
	fi
}
#@end_function

FUNCTION_HELP[ls]=$(
	cat <<'EOF'
NAME
    ls - Enhanced directory listing with fallback support

DESCRIPTION
    A smart wrapper around eza, exa, or native ls. Uses $LS_COMMAND to decide
    which tool to use. Provides consistent formatting with icons, git status,
    and color.

USAGE
    ls [options] [path]

OPTIONS
    --help, -h
        Show this help message
    All other options are passed to the underlying command (eza/exa/ls)

EXAMPLES
    ls
        List current directory with enhanced view
    ls -l
        Pass -l to underlying tool
    ls --help
        Show this message

CONFIGURATION
    Set LS_COMMAND=eza  (or exa, ls) to control behavior
EOF
)
#@begin_function
function ls()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	local cmd
	case "$LS_COMMAND" in
	eza)
		cmd="eza --all --long --header --git --icons --group-directories-first --color=always"
		;;
	exa)
		cmd="exa --all --long --header --git --icons --group-directories-first --color=always"
		;;
	ls | "")
		cmd="command ls -lahg --color=always --group-directories-first"
		;;
	*)
		echo "Unknown LS_COMMAND: $LS_COMMAND, falling back to ls" >&2
		cmd="command ls -lahg --color=always --group-directories-first"
		;;
	esac

	eval "$cmd \"\$@\""
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

#@Name: dupebyname
#@Description: This is an example function
#@Usage: dupebyname [argument]
#@define help information
FUNCTION_HELP[dupebyname]=$(
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
#@begin_function dupebyname
function dupebyname()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	find -- * -maxdepth 0 -type d | cut -d "." -f 1,2,3,4,5 | uniq -c
}
#@end_function

# Function to backup file by appending .bk to the end of the file name
#@begin_function bk
function bk()
{
	# Indirect help check
	handle_help "${FUNCNAME[0]}" "$@" && return 0

	cp "$1" "$1_$(date +"%Y-%m-%d_%H-%M-%S")".bk
}
#@end_function

# Function to convert hex to Asciic
#@begin_function hexToAscii
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