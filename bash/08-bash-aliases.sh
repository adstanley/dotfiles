#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        08-bash-aliases.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines bash aliases and functions.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

#################################################################################
#####                            Aliases                                    #####
#################################################################################

# Directory shortcuts
alias cd_sab='cd /mnt/spool/SABnzbd/Completed'
alias cd_torrent='cd /mnt/spool/torrent'
alias cd_pron='cd /mnt/z2pool/Pr0n'

# Drive shortcuts TrueNAS
alias cd_mach2='cd /mnt/mach2'
alias cd_seagatemirror='cd /mnt/seagatemirror'
alias cd_spool='cd /mnt/spool'
alias cd_spool-temp='cd /mnt/spool-temp'
alias cd_toshiba='cd /mnt/toshiba'
alias cd_toshiba2='cd /mnt/toshiba2'
alias cd_toshiba3='cd /mnt/toshiba3'
alias cd_toshiba4='cd /mnt/toshiba4'
alias cd_toshiba5='cd /mnt/toshiba5'
alias cd_toshiba6='cd /mnt/toshiba6'

# Drive shortcuts TrueNAS2
alias cd_pron='cd /mnt/z2pool/Pr0n'
alias cd_zpool2='cd /mnt/z2pool'
alias cd_zpool='cd /mnt/zpool'

# Alias to edit/reload bashrc
alias reload='source ~/.bashrc'
alias nanobash='nano ~/.bashrc'
alias nvimbash='nvim ~/.bashrc'
alias rc='nvim ~/.bashrc && exec $SHELL -l'

# Some more alias to avoid making mistakes:
alias rm='rm -vI'
alias cp='cp -vi'
alias mv='mv -vi'
alias mkdir='mkdir -pv'

# Colorize grep output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Directory Shortcuts
alias getfiles="find -- * -type f" # Find all files in the current directory
alias getfolders="find -- * type d" # Find all folders in the current directory

# k3s Shortcuts
alias pods='k3s kubectl get pods --all-namespaces'
alias showfailed='systemctl list-units --state failed'
alias namespaces='k3s kubectl get namespaces'

# Rclone / Rsync progress
alias cpv='rsync -ah --info=progress2'

# Truetool script Shortcut
alias truetool='bash ~/truetool/truetool.sh'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"