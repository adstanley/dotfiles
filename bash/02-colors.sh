#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        02-colors.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines color-related variables and functions.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

## ANSI Escape Codes
# Colors
BLACK='\[\033[01;30m\]'    # Black
RED='\[\033[01;31m\]'      # Red
GREEN='\[\033[01;32m\]'    # Green
YELLOW='\[\033[01;33m\]'   # Yellow
BLUE='\[\033[01;34m\]'     # Blue
PURPLE='\[\033[01;35m\]'   # Purple
CYAN='\[\033[01;36m\]'     # Cyan
WHITE='\[\033[01;37m\]'    # White
GREEN="\[\033[38;5;2m\]"   # Green
YELLOW="\[\033[38;5;11m\]" # Yellow
BLUE="\[\033[38;5;6m\]"    # Blue
RESET='\[\033[0m\]'        # Reset

# Text Attributes
BOLD='\033[01m'      # Bold ANSI escape code
UNDERLINE='\033[04m' # Underline ANSI escape code
ITALIC='\033[03m'    # Italic ANSI escape code


# Colored GCC warnings and errors
# Errors will be displayed in bold red
# Warnings will be displayed in bold purple
# Notes will be displayed in bold cyan
# Carets will be displayed in bold green
# Locus will be displayed in bold white
# Quotes will be displayed in bold yellow
export GCC_COLORS="error=${BOLD};${RED//\\\[/}:warning=${BOLD};${PURPLE//\\\[/}:note=${BOLD};${CYAN//\\\[/}:caret=${BOLD};${GREEN//\\\[/}:locus=${BOLD}:quote=${BOLD};${YELLOW//\\\[/}"
