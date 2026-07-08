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
BLACK="\e[0;30m"  # Black
RED="\e[0;31m"       # Red
GREEN="\e[0;32m"     # Green
YELLOW="\e[0;33m"    # Yellow
BLUE="\e[0;34m"      # Blue
PURPLE="\e[0;35m"    # Purple
CYAN="\e[0;36m"      # Cyan
WHITE="\e[0;37m"     # White
GREEN="\e[38;5;2m"   # Green
YELLOW="\e[38;5;11m" # Yellow
BLUE="\e[38;5;6m"    # Blue
RESET="\e[0m"        # Reset

# Text Attributes
BOLD="\e[01m"      # Bold ANSI escape code
UNDERLINE="\e[04m" # Underline ANSI escape code
ITALIC="\e[03m"    # Italic ANSI escape code


# Colored GCC warnings and errors
# Errors will be displayed in bold red
# Warnings will be displayed in bold purple
# Notes will be displayed in bold cyan
# Carets will be displayed in bold green
# Locus will be displayed in bold white
# Quotes will be displayed in bold yellow
export GCC_COLORS="error=${BOLD};${RED//\\\[/}:warning=${BOLD};${PURPLE//\\\[/}:note=${BOLD};${CYAN//\\\[/}:caret=${BOLD};${GREEN//\\\[/}:locus=${BOLD}:quote=${BOLD};${YELLOW//\\\[/}"
