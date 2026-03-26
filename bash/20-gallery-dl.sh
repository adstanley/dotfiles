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
    local GALLERY_DL_PATH="${HOME}/.python/gallery-dl/bin/gallery-dl"
    local DEST_DIR="${HOME}/.gallery-dl"

    "${GALLERY_DL_PATH}" "${URL}" -d "${DEST_DIR}"

}
