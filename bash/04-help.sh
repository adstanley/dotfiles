#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        04-help.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines help functions.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

# Declare associative array for function help
declare -A FUNCTION_HELP

#################################################################################
#                                    Help                                       #
#################################################################################

#@Name: handle_help
#@define help information
FUNCTION_HELP[handle_help]=$(
    cat <<'EOF'
NAME
    handle_help - Display help message for a given function

DESCRIPTION
    Checks if the second argument is --help or -h and prints the help message
    stored in the FUNCTION_HELP associative array for the specified function name.

USAGE
    handle_help <function_name> [--help|-h]
	handle_help "${FUNCNAME[0]}" "$@" && return 0

OPTIONS
    <function_name> : Name of the function to display help for
    --help, -h      : Show this help message and exit

EXAMPLES
    handle_help cd_drive --help
        Prints the help message for the cd_drive function.
EOF
)
#@begin_function
handle_help() {
    # if $BASH_DEBUG; then
    #    printf "Debug: print function name: %s\n" "$@"
    #    printf "Debug: handle_help called with function name: %s\n" "$1"
    #    printf "Debug: handle_help called with arguments: %s\n" "$*"
    # fi

    local func_name="$1"
    shift
    local verbose=false
    # if [[ "$1" == "--verbose" || "$1" == "-v" ]]; then
    #     verbose=true
    #     shift
    # fi
    if [[ -z "$func_name" ]]; then
        printf "Error: No function name provided to handle_help\n" >&2
        return 3
    fi
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[$func_name]}" ]]; then
            echo "${FUNCTION_HELP[$func_name]}"
            if [[ "$verbose" == true ]]; then
                echo -e "\nFunction definition:"
                type "$func_name"
            fi
            return 0
        else
            printf "Help not available for function: %s\n" "$func_name" >&2
            return 2
        fi
    fi
    return 1
}
#@end_function

#@Name: handle_help
#@define help information
FUNCTION_HELP[list_functions]=$(
    cat <<'EOF'
NAME
    list_functions

DESCRIPTION
    Show all FUNCTION_HELP array entries

USAGE
    list_functions

OPTIONS
    none

EXAMPLES
    list_functions
EOF
)
#@begin_function
list_functions() {
    printf "Available functions with help:\n"
    for func in "${!FUNCTION_HELP[@]}"; do
        printf "%s\n" "$func"
    done | sort
}
#@end_function
