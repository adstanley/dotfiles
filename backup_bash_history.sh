#!/usr/bin/env bash
#
# This script creates monthly backups of the bash history file. Make sure you have
# HISTSIZE set to large number (more than number of commands you can type in every
# month). It keeps last 200 commands when it "rotates" history file every month.
# Typical usage in a bash profile:
#
# HISTSIZE=90000
# source ~/bin/history-backup
#
# And to search whole history use:
# grep xyz -h --color ~/.bash_history.*
#

# KEEP=200
# BASH_HIST=~/.bash_history
# BACKUP=$BASH_HIST.$(date +%y%m)

# if [ -s "$BASH_HIST" -a "$BASH_HIST" -nt "$BACKUP" ]; then
#   # history file is newer then backup
#   if [[ -f $BACKUP ]]; then
#     # there is already a backup
#     cp -f $BASH_HIST "$BACKUP"
#   else
#     # create new backup, leave last few commands and reinitialize
#     mv -f $BASH_HIST "$BACKUP"
#     tail -n $KEEP $BACKUP > $BASH_HIST
#     history -r
#   fi
# fi

# Bash history backup script

# Configuration
BACKUP_DIR="$HOME/.bash_history_backups"
HISTORY_FILE="$HOME/.bash_history"
MAX_BACKUPS=30  # Maximum number of backups to keep

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create a timestamp for the backup file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/bash_history_$TIMESTAMP.bak"

# Backup the history file
cp "$HISTORY_FILE" "$BACKUP_FILE"

# Compress the backup
gzip "$BACKUP_FILE"

echo "Bash history backed up to $BACKUP_FILE.gz"

# Remove old backups if we have more than MAX_BACKUPS
num_backups=$(find "$BACKUP_DIR" -maxdepth 1 -name "bash_history_*.bak.gz" | wc -l)
if [ "$num_backups" -gt "$MAX_BACKUPS" ]; then
    num_to_delete=$((num_backups - MAX_BACKUPS))
    find "$BACKUP_DIR" -maxdepth 1 -name "bash_history_*.bak.gz" -printf "%T@ %p\n" | 
        sort -n | head -n "$num_to_delete" | cut -d' ' -f2- | xargs rm
    echo "Removed $num_to_delete old backup(s)"
fi

# Optionally, add this line to your .bashrc to run this script every time you log in
# /path/to/this/script.sh