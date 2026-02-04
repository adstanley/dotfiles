#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        20-gallery-dl.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines functions for downloading galleries using gallery-dl.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

# Declare associative array for function help
declare -A FUNCTION_HELP

function gallery_download() {
    # indirect help check
    handle_help "$@" && return 0

    local URL="$1"

    "${HOME}"/.python/gallery-dl/bin/gallery-dl "${URL}" -d /home/sigmachad/.gallery-dl

}