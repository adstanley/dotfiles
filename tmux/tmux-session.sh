#!/usr/bin/env bash

usage() {
    printf "Usage: %s [path]\n" "$(basename "$0")"
    printf "       %s [path] [directory]\n" "$(basename "$0")"
    printf "       %s [path] [directory] [file]\n" "$(basename "$0")"
    exit 1 
}

parse_args() {
    if [[ $# -eq 0 ]]; then
        usage
    fi

    local opt
    for opt in "$@"; do
        case $opt in
            -h|--help)
                usage
                ;;
            -*)
                echo "Unknown option: $opt" >&2
                usage
                ;;
            *)
                # This is a positional argument, continue processing
                ;;
        esac
    done
}

# Parse command line arguments
parse_args "$@"

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find "$HOME/.project" -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s "$selected_name" -c "$selected"
    exit 0
fi

if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
nvim