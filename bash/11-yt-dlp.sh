#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        11-yt-dlp.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines yt-dlp aliases and functions.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

# yt-dlp
alias yta-aac="yt-dlp --extract-audio --audio-format aac"
alias yta-best="yt-dlp --extract-audio --audio-format best"
alias yta-flac="yt-dlp --extract-audio --audio-format flac"
alias yta-m4a="yt-dlp --extract-audio --audio-format m4a"
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3"
alias yta-opus="yt-dlp --extract-audio --audio-format opus"
alias yta-vorbis="yt-dlp --extract-audio --audio-format vorbis"
alias yta-wav="yt-dlp --extract-audio --audio-format wav"
alias ytv-best="yt-dlp -f bestvideo+bestaudio"