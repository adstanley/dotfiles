#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        19-tmux.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines tmux-related aliases and functions.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# Declare associative array for function help
declare -A FUNCTION_HELP

# --- FILE CONTENT STARTS HERE --- #


reattach_client() {
  if [[ $# -lt 1 ]]; then
    echo -e "Usage:\nreattach_client <tmux_session_name>"
    return
  fi
  tmux list-client | grep "$1" | awk '{split($1, s, ":"); print s[1]}' | xargs tmux detach-client -t || true
  tmux attach -t "$1"
}