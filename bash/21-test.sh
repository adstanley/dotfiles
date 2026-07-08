#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        21-test.sh
# AUTHOR:      Sigmachad
# DATE:        2026-06-19
# DESCRIPTION: Defines tmux-related aliases and functions.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# Declare associative array for function help
declare -A FUNCTION_HELP

# --- FILE CONTENT STARTS HERE --- #

print_args() {
    printf "Function Name: %s\n" "${FUNCNAME[0]}"
    printf "Arguments: %s\n" "$*"
    printf "Argument Count: %d\n" "$#"
}
