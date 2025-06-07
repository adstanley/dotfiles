#!/usr/bin/env bash
# Script Name: basic_name_match.sh
# Description: A script to generate a regex pattern to match folders with a specific naming convention
#
# Shellcheck directives
# shellcheck source=/dev/null
# shellcheck disable=SC2034
# shellcheck disable=SC2162

# shell options
# set -e # Exit on error
# set -u # Exit on using unset variable
# set -x # Print command before execution

# Declare associative array for function help
declare -A FUNCTION_HELP

#@Name: makeAlias
#@Description: Create an alias from the last command in history
#@Arguments: [alias_name]
#@Usage: makeAlias [alias_name]
#@define help information
FUNCTION_HELP[makeAlias]=$(cat << 'EOF'
NAME
    makeAlias - Create an alias from the last command in history

DESCRIPTION
    Create an alias from the last command in history. The alias will be saved in ~/.bash_aliases.
    If no alias name is provided, the function will print an error message.

USAGE
    makeAlias [ALIAS_NAME]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES
    makeAlias myalias
        Create an alias named 'myalias' from the last command in history.

    makeAlias
        No alias name provided, will print an error message.

    makeAlias --help
        Show this help message and exit.
EOF
)

#@begin_function
function makeAlias() {
    local alias_name=""
    local show_help=false
    
    # Parse options with getopts
    while getopts "h" opt; do
        case $opt in
            h)
                show_help=true
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                echo "Usage: makeAlias [-h] [alias_name]"
                return 1
                ;;
        esac
    done
    
    # Shift past the options
    shift $((OPTIND-1))
    
    # Handle --help (long option)
    if [[ "$1" == "--help" ]]; then
        show_help=true
        shift
    fi
    
    # Show help if requested
    if [[ "$show_help" == true ]]; then
        echo "${FUNCTION_HELP[makeAlias]}"
        return 0
    fi
    
    # Check if alias name is provided
    if [[ $# -eq 0 ]]; then
        echo "Error: No alias name provided." >&2
        echo "Usage: makeAlias [-h] [alias_name]"
        return 1
    fi
    
    # Check for too many arguments
    if [[ $# -gt 1 ]]; then
        echo "Error: Too many arguments. Expected exactly one alias name." >&2
        echo "Usage: makeAlias [-h] [alias_name]"
        return 1
    fi
    
    alias_name="$1"
    
    # Validate alias name format
    if [[ ! "$alias_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo "Error: Invalid alias name '$alias_name'." >&2
        echo "Alias names must start with a letter or underscore and contain only letters, numbers, and underscores."
        return 1
    fi
    
    # Check if alias already exists
    if alias "$alias_name" &>/dev/null; then
        echo "Error: Alias '$alias_name' already exists. Please choose a different name." >&2
        return 1
    fi
    
    # Get the last command from history
    local last_command
    last_command=$(history | tail -n 2 | head -n 1 | sed 's/^[ ]*[0-9]*[ ]*//')
    
    if [[ -z "$last_command" ]]; then
        echo "Error: Could not retrieve last command from history." >&2
        return 1
    fi
    
    # Escape single quotes in the command
    local escaped_command="${last_command//\'/\'\\\'\'}"
    
    # Add alias to ~/.bash_aliases
    echo "alias $alias_name='$escaped_command'" >> ~/.bash_aliases
    
    # Source the aliases file to make it available immediately
    if [[ -f ~/.bash_aliases ]]; then
        source ~/.bash_aliases
    fi
    
    echo "Alias '$alias_name' created successfully for command: $last_command"
    return 0
}