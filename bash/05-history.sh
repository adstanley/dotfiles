#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        04-history.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines bash history settings.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

# Declare associative array for function help
declare -A FUNCTION_HELP

## Bash history
HISTCONTROL=ignoredups:erasedups                            # don't put duplicate lines in the history.
HISTSIZE=2147483647                                         # set history length, non integer values set history to infinite
HISTFILESIZE=2147483647                                     # set file size, non integer values set history to infinite
HISTTIMEFORMAT="%F %T "                                     # set history time format, %F = full date, %T = time
HISTFILE="${HOME}/.bash_history"                            # set history file location
HISTBACKUPDIR="${HOME}/.bash_history_backups"               # set history backup directory
HISTFILEBACKUP="${HOME}/${HISTBACKUPDIR}/.bash_history.bak" # set history backup file location
HISTIGNORE="&:ls:[bf]g:exit:cd*\`printf*\\0057*"            # ignore these midnight commander entries

## History options
shopt -s histappend # append to the history file, don't overwrite it
shopt -s cmdhist    # try to save all lines of a multiple-line command in the same history entry

#@Name: backup_history
#@Description: Backup bash history file
#@Usage: backup_history
FUNCTION_HELP[backup_history]=$(
    cat <<'EOF'
NAME
    backup_history - Backup bash history file
DESCRIPTION
    Creates a backup copy of the current bash history file in a designated backup directory.
USAGE
    backup_history
EOF
)
#@begin_function backup_history
backup_history()
{
    mkdir -p "$HISTBACKUPDIR"
    local timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    cp -a "$HISTFILE" "$HISTBACKUPDIR/bash_history.$timestamp"
    # Optional: keep only last N backups
    find "$HISTBACKUPDIR" -name 'bash_history.*' -printf '%T+ %p\n' |
        sort | head -n -20 | cut -d' ' -f2- | xargs -r rm
}
#@end_function

#@name hist
#@description Search bash history with colorized output
#@usage hist [search_term]
#@example hist ssh
#@begin_function hist
function hist()
{
    # Indirect help check
    handle_help "${FUNCNAME[0]}" "$@" && return 0

    # If no arguments → just show full history
    (($# == 0)) && {
        history
        return 0
    }

    # Join ALL arguments with spaces → this becomes our search string
    local search="$*"

    # Optional: trim output to 100 lines
    local trim="false"
    if [[ " $1 " == " -t " || " $1 " == " --trim " ]]; then
        trim="true"
        shift
    fi

    if [[ "$trim" == "true" ]]; then
        history | grep "$search" | awk '
        {
            printf "\033[1;34m%5d\033[0m \033[1;36m%s %s\033[0m \033[1;32m%s\033[0m\n", $1, $2, $3, substr($0, index($0,$4))
        }' | tail -n 100
        
    else
        # Use grep for simple text filtering ONLY, then let awk apply ALL colors
        # Apply color codes for: History Number (1;34m), Timestamp (1;36m), Command (1;32m)
        history | grep "$search" | awk '
        {
            printf "\033[1;34m%5d\033[0m \033[1;36m%s %s\033[0m \033[1;32m%s\033[0m\n", $1, $2, $3, substr($0, index($0,$4))
        }'
    fi
}
#@end_function
