###########################################################
#  ____ ___ ____ __  __    _    ____ _   _    _    ____   #
# / ___|_ _/ ___|  \/  |  / \  / ___| | | |  / \  |  _ \  #
# \___ \| | |  _| |\/| | / _ \| |   | |_| | / _ \ | | | | #
#  ___) | | |_| | |  | |/ ___ \ |___|  _  |/ ___ \| |_| | #
# |____/___\____|_|  |_/_/   \_\____|_| |_/_/   \_\____/  #
#                                                         #
#    ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗     #
#    ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝     #
#    ██████╔╝███████║███████╗███████║██████╔╝██║          #
#    ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║          #
#    ██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗     #
#    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝     #
#                            http://github.com/adstanley  #
#                                    http://sigmachad.io  #
#                                            Chet Manley  #
###########################################################
#
# Bashrc
# Shellcheck Directvies
# shellcheck shell=bash
# shellcheck source=/dev/null
# shellcheck disable=SC1090
# shellcheck disable=SC1091
# shellcheck disable=SC2034
#
# 1. Environmental Variables / Bash Options
# 2. Aliases
# 3. Functions
#
#
#################################################################################
# Options                                                                       #
#################################################################################

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Add to PATH first 
if [ -d "${HOME}/.bin" ]; then
    PATH="${HOME}/.bin:$PATH"
fi

if [ -d "${HOME}/.local/bin" ]; then
    PATH="${HOME}/.local/bin:$PATH"
fi

# if using multiple files for bashrc
if [ -f "${HOME}/.bash_directory" ]; then
    source "${HOME}/.bash_directory"
fi

# Source custom completion scripts
if [ -d "${HOME}/.bash_completion.d" ]; then
    for file in "${HOME}"/.bash_completion.d/* ; do
        source "$file"
    done
fi

## "bat" as manpager
if command -v bat >/dev/null 2>&1; then
    export MANPAGER="bat"
    # export MANPAGER="nvim -c 'set ft=man' -"
else
    export MANPAGER="less"
fi

## if nvim is installed, set as default editor
if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
else
    export EDITOR="nano"
fi

## Bash history
HISTCONTROL=ignoredups:erasedups    # don't put duplicate lines in the history.
HISTSIZE='INFINITE'                 # set history length, non integer values set history to infinite
HISTFILESIZE='STONKS'               # set file size, non integer values set history to infinite
HISTTIMEFORMAT="%F %T "             # set history time format, %F = full date, %T = time
HISTIGNORE="&:ls:[bf]g:exit"        # ignore these commands in history
shopt -s histappend                 # append to the history file, don't overwrite it
shopt -s cmdhist                    # try to save all lines of a multiple-line command in the same history entry

## Shell Options
# Set options
set -o noclobber        # Prevent overwriting files
# set -o vi             # Set vi mode, Allows for vi keybindings in the terminal

# Shopt Options
shopt -s autocd         # change to named directory
shopt -s cdspell        # autocorrects cd misspellings
shopt -s cmdhist        # save multi-line commands in history as single line
shopt -s dotglob        # include hidden files in globbing
shopt -s histappend     # do not overwrite history
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize   # checks term size when bash regains control
shopt -s extglob        # extended pattern matching
shopt -s globstar       # recursive globbing
shopt -s histverify     # show command with history expansion to allow editing
shopt -s nullglob       # null globbing, no match returns null

## Environmental Variables
if [ -z "$XDG_CONFIG_HOME" ]; then
    export XDG_CONFIG_HOME="${HOME}/.config"
fi
if [ -z "$XDG_DATA_HOME" ]; then
    export XDG_DATA_HOME="${HOME}/.local/share"
fi
if [ -z "$XDG_CACHE_HOME" ]; then
    export XDG_CACHE_HOME="${HOME}/.cache"
fi

## Prompt
# PS1    The  value  of  this parameter is expanded (see PROMPTING below)
#        and used as the primary prompt string.   The  default  value  is
#        ``\s-\v\$ ''.
# PS2    The  value of this parameter is expanded as with PS1 and used as
#        the secondary prompt string.  The default is ``> ''.
# PS3    The value of this parameter is used as the prompt for the select
#        command (see SHELL GRAMMAR above).
# PS4    The  value  of  this  parameter  is expanded as with PS1 and the
#        value is printed before each command  bash  displays  during  an
#        execution  trace.  The first character of PS4 is replicated mul‐
#        tiple times, as necessary, to indicate multiple levels of  indi‐
#        rection.  The default is ``+ ''.

# TODO: Breaks line feed
## ANSI Escape Codes
# Colors
# BLACK=$(tput setaf 0)   # \033[1;30m - Black
# RED=$(tput setaf 1)     # \033[1;31m - Red
# GREEN=$(tput setaf 2)   # \033[1;32m - Green
# YELLOW=$(tput setaf 3)  # \033[1;33m - Yellow
# BLUE=$(tput setaf 4)    # \033[1;34m - Blue
# PURPLE=$(tput setaf 5)  # \033[1;35m - Purple (Magenta)
# CYAN=$(tput setaf 6)    # \033[1;36m - Cyan
# WHITE=$(tput setaf 7)   # \033[1;37m - White
# RESET=$(tput sgr0)      # \033[0m - Reset all attributes

## ANSI Escape Codes
# Colors
BLACK='\[\033[01;30m\]'     # Black
RED='\[\033[01;31m\]'       # Red
GREEN='\[\033[01;32m\]'     # Green
YELLOW='\[\033[01;33m\]'    # Yellow
BLUE='\[\033[01;34m\]'      # Blue
PURPLE='\[\033[01;35m\]'    # Purple
CYAN='\[\033[01;36m\]'      # Cyan
WHITE='\[\033[01;37m\]'     # White
GREEN="\[\033[38;5;2m\]"    # Green
YELLOW="\[\033[38;5;11m\]"  # Yellow
BLUE="\[\033[38;5;6m\]"     # Blue     

# Text Attributes
BOLD='\033[01m'             # Bold ANSI escape code

# Colored GCC warnings and errors
# Errors will be displayed in bold red
# Warnings will be displayed in bold purple
# Notes will be displayed in bold cyan
# Carets will be displayed in bold green
# Locus will be displayed in bold white
# Quotes will be displayed in bold yellow
# export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GCC_COLORS="error=${BOLD};${RED//\\\[/}:warning=${BOLD};${PURPLE//\\\[/}:note=${BOLD};${CYAN//\\\[/}:caret=${BOLD};${GREEN//\\\[/}:locus=${BOLD}:quote=${BOLD};${YELLOW//\\\[/}"

# Set Prompt
PS1="${debian_chroot:+(${debian_chroot})}${YELLOW}\u${RESET}@${GREEN}\h${RESET}:${BLUE}[\w]${RESET} > ${RESET}"

## Change title of terminals
case ${TERM} in
xterm* | rxvt* | Eterm* | aterm | kterm | gnome* | alacritty | st | konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
    ;;
screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac

# if using debian, set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

#################################################################################
#################################### Aliases ####################################
#################################################################################

# Alias to edit/reload bashrc
alias reload='source ~/.bashrc'
alias nanobash='nano ~/.bashrc'
alias rc='nvim ~/.bashrc && exec $SHELL -l'

# Some more alias to avoid making mistakes:
alias rm='rm -vI'
alias cp='cp -vi'
alias mv='mv -vi'
alias mkdir='mkdir -pv'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Exa alias settings
alias eza='eza -lahg --color=always --icons --group-directories-first'
alias ls='eza -lahg --color=always --icons --group-directories-first' # list all files colorized in long format

# Directory Shortcuts
# alias flatten='find * -type f -exec mv '{}' . \;' # Flatten directory structure
alias getfiles="find -- * -type f"                # Find all files in the current directory
alias extensions="find -- * -type f | sed -e 's/.*\.//' | sed -e 's/.*\///'" # Find all file extensions in the current directory

# k3s Shortcuts
alias pods='k3s kubectl get pods --all-namespaces'
alias showfailed='systemctl list-units --state failed'
alias namespaces='k3s kubectl get namespaces'

# Rclone / Rsync progress
alias cpv='rsync -ah --info=progress2'

# Truetool script Shortcut
alias truetool='bash ~/truetool/truetool.sh'


## ZFS Aliases
# iostat
alias iostat='zpool iostat -vly 5 1'
alias zdb='zdb -U /data/zfs/zpool.cache'

# get snapshots
alias snapshot='zfs list -t snapshot'
alias snapshot1='zfs list -H -o name -t snapshot'

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# get diskspace
alias diskspace="du -S | sort -n -r | less"
alias df='df -h'     # human-readable sizes
alias free='free -m' # show sizes in MB

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# yt-dlp
alias yta-aac="yt-dlp --extract-audio --audio-format aac "
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias yta-flac="yt-dlp --extract-audio --audio-format flac "
alias yta-m4a="yt-dlp --extract-audio --audio-format m4a "
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias yta-opus="yt-dlp --extract-audio --audio-format opus "
alias yta-vorbis="yt-dlp --extract-audio --audio-format vorbis "
alias yta-wav="yt-dlp --extract-audio --audio-format wav "
alias ytv-best="yt-dlp -f bestvideo+bestaudio "

# bare git repo alias for dotfiles
alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'

# bash linter
alias shellcheck='docker run --rm -v "$(pwd)":/mnt koalaman/shellcheck'

# AppImage Aliases
alias nvim='~/nvim.appimage'

#################################################################################
################################### Functions ###################################
#################################################################################


#@begin_function countfields
# Name: countfields
# Description: Count the number of fields in a directory name
# Arguments: [directory]
# Usage: countfields [directory] 
function countfields() {
    # if $1 is empty, use "*"
    local target_dir="${1:-*}"

    find -- "$target_dir" -maxdepth 0 -type d | awk -F"." '{print NF, $0}' | sort -nr | uniq -c
}
#@end_function


#@begin_function dupebyname
# Name: example
# Description: This is an example function
# Usage: example [argument]
function dupebyname() {
    find -- * -maxdepth 0 -type d | cut -d "." -f 1,2,3,4,5 | uniq -c
}
#@end_function

#@begin_function ownroot
# Name: example
# Description: This is an example function
# Usage: example [argument]
function ownroot() {
    # "${1:-.}" = if $1 is empty, use "."
    local target_dir="${1:-.}"

    # Check if the target directory exists
    if [ ! -d "$target_dir" ]; then
        printf "Error: %s is not a directory.\n" "$target_dir" >&2
        return 1
    fi

    # Change ownership recursively
    chown -R -v root:root "$target_dir"
}
#@end_function

#@begin_function mod775
# Name: mod775
# Description: modify permissions to 775, will default to current directory
# Usage: mod775 ./
function mod775() {
    # "${1:-.}" = if $1 is empty, use "."
    local target_dir="${1:-.}"

    # Check if the target directory exists
    if [ ! -d "$target_dir" ]; then
        printf "Error: %s is not a directory.\n" "$target_dir" >&2
        return 1
    fi

    # Change ownership recursively
    chmod -R -v 775 "$target_dir"
}
#@end_function

# Git
#@begin_function git_shallow
function git_shallow() {
    if [ "$1" = "clone" ]; then
        shift 1
        command git clone --depth=1 "$@"
    else
        command git "$@"
    fi
}
#@end_function

#@begin_function
# Name: git_branch
# Description: Shows current git branch
# Usage: git_branch
function git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
#@end_function

# Move Check
#@begin_function mv_check
function mv_check() {

    # Function for checking syntax of mv command
    # sort of verbose dry run
    # Now supports the -t flag

    # check if -t flag is present
    if [ "$1" = "-t" ]; then
        if [ $# -lt 3 ]; then
            printf "<<< ERROR: with -t flag, must have at least 3 arguments, but %s given " "$#" >&2
            return 1
        fi

        target_dir="$2"
        shift 2

        # check if target directory exists
        if [ ! -d "$target_dir" ]; then
            printf "<<< ERROR: target directory %s doesn't exist" "$target_dir" >&2
            return 1
        fi

        for src in "$@"; do
            if ! readlink -e "$src" >/dev/null; then
                printf "<<< ERROR: %s doesn't exist" "$src" >&2
                return 1
            fi
            printf "Moving %s into %s directory" "$src" "$target_dir"
        done
    else
        # check number of arguments
        if [ $# -ne 2 ]; then
            printf "<<< ERROR: must have 2 arguments, but %d given " "$#" >&2
            return 1
        fi

        src="$1"
        dest="$2"

        # check if source item exists
        if ! readlink -e "$src" >/dev/null; then
            printf "<<< ERROR: %s doesn't exist" "$src" >&2
            return 1
        fi

        # check where file goes
        if [ -d "$dest" ]; then
            printf "Moving %s into %s directory" "$src" "$dest"
        else
            printf "Renaming %s to %s" "$src" "$dest"
        fi
    fi
}
#@end_function


# Move Function
#@begin_function rclonemove
function rclonemove() {
    # Check number of arguments
    if [ $# -ne 2 ]; then
        printf "<<< ERROR: Must have 2 arguments, but %d given.\n" "$#" >&2
        return 1
    fi

    # Check if source exists
    local source
    if ! source=$(readlink -e "$1"); then
        printf "<<< ERROR: Source \"%s\" doesn't exist or is not accessible.\n" "$1" >&2
        return 1
    fi

    local destination="$2"
    local parent_dir
    parent_dir=$(dirname "$destination")

    # Check if parent directory of destination exists
    if [ ! -d "$parent_dir" ]; then
        printf "Parent directory of destination \"%s\" doesn't exist.\n" "$parent_dir"
        read -p "Do you want to create it? (y/n): " -n 1 -r
        echo    # Move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mkdir -p "$parent_dir"
        else
            printf "Operation cancelled.\n"
            return 1
        fi
    fi

    printf "Moving \"%s\" to \"%s\".\n" "$source" "$destination"
    rclone move -P --ignore-existing --transfers 4 --order-by size,mixed,75 "$source" "$destination"
}
#@end_function

# Copy Function
#@begin_function rclonecopy
function rclonecopy() {
    # Check number of arguments
    if [ $# -ne 2 ]; then
        printf "<<< ERROR: Must have 2 arguments, but %d given.\n" "$#" >&2
        return 1
    fi

    # Check if source exists
    local source
    if ! source=$(readlink -e "$1"); then
        printf "<<< ERROR: Source \"%s\" doesn't exist or is not accessible.\n" "$1" >&2
        return 1
    fi

    local destination="$2"
    local parent_dir
    parent_dir=$(dirname "$destination")

    # Check if parent directory of destination exists
    if [ ! -d "$parent_dir" ]; then
        printf "Parent directory of destination \"%s\" doesn't exist.\n" "$parent_dir"
        read -p "Do you want to create it? (y/n): " -n 1 -r
        echo    # Move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mkdir -p "$parent_dir"
        else
            printf "Operation cancelled.\n"
            return 1
        fi
    fi

    printf "Copying \"%s\" to \"%s\".\n" "$source" "$destination"
    rclone copy -P --ignore-existing --transfers 4 --order-by size,mixed,75 "$source" "$destination"
}
#@end_function

# Function to find largest files in the current directory
#@begin_function find_largest_files
function find_largest_files() {
    du -h -x -s -- * | sort -r -h | head -20;
}
#@end_function

# Function to backup file by appending .bk to the end of the file name
#@begin_function bk
function bk() {
    cp "$1" "$1_$(date +"%Y-%m-%d_%H-%M-%S")".bk
}
#@end_function

# Function to convert hex to Asciic
#@begin_function hexToAscii
function hexToAscii() {
    printf "\x%s" "$1"
}
#@end_function

# idk man
#@begin_function c2f
function c2f() {
    fc -lrn | head -1 >>"${1?}"
}
#@end_function

# Get history
#@begin_function hist
function hist() {

    if [ -z "$1" ]; then
        history
        return 0
    fi

    history | grep "$1"
}
#@end_function

#@begin_function findd
function findd() {
    printf "Searching for *%s*. \n" "$1"
    find -- * -iname "*$1*" -type d
}
#@end_function

#@begin_function findf
function findf() {
    printf "Searching for *%s*. \n" "$1"
    find -- * -iname "*$1*" -type f
}
#@end_function

# Create a .7z compressed file with maximum compression
# Example: 7zip "/path/to/folder_or_file" "/path/to/output.7z"
#@begin_function 7zip
function 7zip() { 
    7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on -mhe=on "$2" "$1" 
}
#@end_function

# Function to extract rar files from incomplete or broken NZB downloads
#@begin_function packs
function packs() {
    printf "extracting rar volumes with out leading zeros.\n"
    { unrar e '*part1.rar' >/dev/null; } 2>&1 # capture stdout and stderr, redirect stderr to stdout and stdout to /dev/null
    printf "extracting rar volumes with leading zeros.\n"
    { unrar e '*part01.rar' >/dev/null; } 2>&1 # capture stdout and stderr, redirect stderr to stdout and stdout to /dev/null
}
#@end_function

# Simple function to identify the type of compression used on a file and extract accordingly
#@begin_function extract
function extract() {
    if [ -z "$1" ]; then #[[ -z STRING ]]	Empty string
        # display usage if no parameters given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
        return 1
    else
        for n in "$@"; do
            if [ -f "${n}" ]; then #[[ -f FILE ]]	File
                case "${n%,}" in
                *.tar.bz2 | *.tar.gz | *.tar.xz | *.tbz2 | *.tgz | *.txz | *.tar)
                    tar xvf "${n}"
                    ;;
                *.lzma) unlzma ./"${n}" ;;
                *.bz2) bunzip2 ./"${n}" ;;
                *.rar) unrar x -ad ./"${n}" ;;
                *.gz) gunzip ./"${n}" ;;
                *.zip) unzip -d "${n%.zip}"./"${n}" ;;
                *.z) uncompress ./"${n}" ;;
                *.7z | *.arj | *.cab | *.chm | *.deb | *.dmg | *.iso | *.lzh | *.msi | *.rpm | *.udf | *.wim | *.xar)
                    7z x ./"${n}"
                    ;;
                *.xz) unxz ./"${n}" ;;
                *.exe) cabextract ./"${n}" ;;
                *)
                    echo "extract: '${n}' - unknown archive method"
                    return 1
                    ;;
                esac
            else
                echo "'${n}' - file does not exist"
                return 1
            fi
        done
    fi
}
#@end_function

### ARCHIVE EXTRACTION
# usage: ex <file>
#@begin_function ex
function ex() {
    if [ -f "$1" ]; then #[[ -z STRING ]]	Empty string
        # display usage if no parameters given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
        return 1
    else
        case $1 in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7zz x "$1" ;;
        *.deb) ar x "$1" ;;
        *.tar.xz) tar xf "$1" ;;
        *.tar.zst) unzstd "$1" ;;
        *)
            echo "extract: '$1' - unknown archive method"
            return 1
            ;;
        esac
    fi
}
#@end_function

# navigation
#@begin_function up
function up() {
    local d=""
    local limit="$1"

    # Default to limit of 1
    if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
        limit=1
    fi

    for ((i = 1; i <= limit; i++)); do
        d="../$d"
    done

    # perform cd. Show error if cd fails
    if ! cd "$d"; then
        echo "Couldn't go up $limit dirs."
    fi
}
#@end_function

#@begin_function printargs
function printargs() {
    for ((i = 1; i <= $#; i++)); do
        printf "Arg %d: %s\n" "$i" "${!i}"
    done
}
#@end_function

# Define the function to show ZFS holds
#@begin_function holds
function holds() {
    zfs get -Ht snapshot userrefs | grep -v $'\t'0 | cut -d $'\t' -f 1 | tr '\n' '\0' | xargs -0 zfs holds
}
#@end_function

#@begin_function deletesnapshot
function deletesnapshot() {
    # Check if the input is empty
    if [ -z "$1" ]; then
        printf "Input is empty\n" >&2
        return 1
    fi

    # List all snapshots for the given dataset
    zfs list -H -o name -t snapshot -r "$1"

    # Prompt the user to confirm the deletion
    read -pr "Delete all snapshots? (y/n) " answer

    # Check if the user confirms
    if [[ $answer =~ ^[Yy] ]]; then
        # Delete all snapshots for the dataset
        zfs list -H -o name -t snapshot -r "$1" | xargs -n1 zfs destroy
    else
        # Print "Aborting..." and exit the function
        printf "Aborting...\n"
    fi
}
#@end_function

#@begin_function takesnapshot
function takesnapshot() {
    # Check if the input is empty
    if [ -z "$1" ]; then
        printf "Input is empty\n" >&2
        return 1 # Exit with error
    fi

    # Check if the zfs command is available
    if ! command -v zfs &>/dev/null; then
        printf "Error: zfs command not found or not installed\n" >&2
        return 1 # Exit with error
    fi

    # Create a snapshot for the given dataset
    if output=$(zfs snapshot "$1@manual-$(date +"%Y-%m-%d_%H-%M-%S")" 2>&1); then
        printf "%s\n" "$output"
    else
        printf "Error: %s\n" "$output" >&2
        return 3 # Exit with error
    fi
}
#@end_function

#@begin_function getsnapshot
function getsnapshot() {
    # Check if the input is empty
    if [ -z "$1" ]; then
        printf "Input is empty\n" >&2
        return 1
    fi

    # Check if the zfs command is available
    if ! command -v zfs &>/dev/null; then
        printf "Error: zfs command not found or not installed\n" >&2
        return 1
    fi

    # Retrieve the list of snapshots for the given dataset
    if output=$(zfs list -H -o name -t snapshot -r "$1" 2>&1); then
        printf "%s\n" "$output"
    else
        printf "Error: %s\n" "$output" >&2
        return 3
    fi
}
#@end_function

#@begin_function getspace
function getspace() {

    # Check if the input is empty
    if [ -z "$1" ]; then
        printf "Input is empty\n" >&2
        return 1
    fi

    # Check if the zfs command is available
    if ! command -v zfs &>/dev/null; then
        printf "Error: zfs command not found or not installed\n" >&2
        return 1
    fi

    # Retrieve the list of snapshots for the given dataset
    # if output=$(zfs list -o space -t snapshot -r "$1" | sort -k3 --human-numeric-sort 2>&1); then
    if output=$(zfs list -H -o space -t snapshot -r "$1" | sort -k3 --human-numeric-sort 2>&1); then
        printf "%s\n" "$output"
    else
        printf "Error: %s\n" "$output" >&2
        return 3
    fi

}
#@end_function

# Function to find all file extensions in the current directory
#@begin_function extensions
function extensions() {
    # Check if the directory is empty
    if [ -d "$PWD" ]; then
        printf "Directory is empty\n" >&2
        return 1
    fi

    find -- * -type f | sed -e 's/.*\.//' | sed -e 's/.*\///' | sort | uniq -c | sort -rn
}
#@end_function

# Takes a alias name and gets the last command from the history. Makes it an
# alias and puts it in .bash_aliases. Be sure to source .bash_aliases in .bashrc
# or this wont work.
#@begin_function makeAlias
function makeAlias() {
    if [ $# -eq 0 ]; then
        echo "No arguments supplied. You need to pass an alias name"
    else
        newAlias=$(history | tail -n 2 | cut -c 8- | sed -e '$ d')
        escapedNewAlias=${newAlias//\'/\'\\\'\'}
        echo "alias $1='${escapedNewAlias}'" >>~/.bash_aliases
        . ~/.bashrc
    fi
}
#@end_function

#@begin_function moveTemplate
function moveTemplate() {
    local -a local="$1"
    for ((i = 0; i < "${#local[@]}"; i++)); do
        if [ -e "${local[$i]}" ]; then
            cp -pvi "${local[$i]}" ./incomplete/
            rm "${local[$i]}"
        else
            echo "Source file '${local[$i]}' does not exist."
        fi
    done
}
#@end_function

#@begin_function insertDirectory
function insertDirectory() {

    local filename insert
    filename="$(readlink "$1")"
    insert="$2"

    if [ ! -d "$PWD"/"$insert" ]; then
        read -rp "Directory '$insert' does not exist. Create Directory? (Y\N) " answer
        if [[ $answer =~ ^[Yy] ]]; then
            mkdir -pv "$insert"
        else
            printf "Aborting...\n"
            return 1
        fi
    fi

    mv -iv "$filename" "$(dirname "$1")/$insert/$(basename "$1")"
}
#@end_function

#@begin_function insertDirectory2
function insertDirectory2() {

    if [ ! -d "$PWD"/"$insert" ]; then
        read -rp "Directory '$insert' does not exist. Create Directory? (Y\N) " answer
        if [[ $answer =~ ^[Yy] ]]; then
            mkdir -pv "$insert"
        else
            printf "Aborting...\n"
            return 1
        fi
    fi

    mv -nv "$(realpath "$1")" "$(dirname "$1")/$insert/$(basename "$1")"
}
#@end_function

#@begin_function flatten_old
function flatten_old() {
    local -a flatten
    readarray -t flatten < <(find . -type f)
    if [ "${#flatten[@]}" -eq 0 ]; then
        printf "No files found in subdirectories.\n" >&2
        return 1
    else
        printf "%s\n" "${flatten[@]}"
        printf "\nFound %s files in %s subdirectories.\n" "${#flatten[@]}" "$(find . -type d | wc -l)"
    fi

    read -rp "This will move all files in subdirectories to the current directory. Continue? (Y\N) : " answer
    if [[ ! $answer =~ ^[Yy] ]]; then
        printf "Aborting...\n" >&2
        return 1
    fi
    for ((i = 0; i < "${#flatten[@]}"; i++)); do
        mv --no-clobber --verbose "${flatten[$i]}" ./
    done
}
#@end_function

#@begin_function flatten
function flatten() {
    local -a flatten
    local -a duplicates
    local current_dir
    current_dir=$(pwd)
    
    readarray -t flatten < <(find "$current_dir" -type f)
    if [ "${#flatten[@]}" -eq 0 ]; then
        printf "No files found in subdirectories.\n" >&2
        return 1
    else
        printf "%s\n" "${flatten[@]}"
        printf "\nFound %s files in %s subdirectories.\n" "${#flatten[@]}" "$(find "$current_dir" -type d | wc -l)"
    fi

    read -rp "This will move all files in subdirectories to the current directory. Continue? (Y\N) : " answer
    if [[ ! $answer =~ ^[Yy] ]]; then
        printf "Aborting...\n" >&2
        return 1
    fi
    for ((i = 0; i < "${#flatten[@]}"; i++)); do
        if ! mv --no-clobber --verbose "${flatten[$i]}" "$current_dir" 2>/dev/null; then
            duplicates+=("${flatten[$i]}")
        fi
    done

    if [ "${#duplicates[@]}" -gt 0 ]; then
        printf "\nThe following files were not moved due to duplicates:\n"
        printf "%s\n" "${duplicates[@]}"
    fi
}
#@end_function

#@begin_function abc
function abc() {
    local n=$1
    local m=$2
    shift 2
    # It's good to log or echo the command for debugging; ensure to quote "$@" to handle spaces correctly.
    args_string="$n $m $*"
    echo "xyz -n '$n' -m '$m' $args_string"
    # Properly quote "$@" to ensure all arguments are passed correctly to the xyz command.
    xyz -n "$n" -m "$m" "$@"
}
#@end_function

#@begin_function nested
function nested() {
    find "$(pwd)" -type d | awk -F'/' '{print $NF}' | sort | uniq -cd
}
#@end_function

#@begin_function nested2
function nested2() {
    find -- * -type d |
        awk -F '/' '{print $NF}' |
        sort |
        uniq -cd |
        while read -r count name; do
            printf "Duplicate directory name found: \n%s (%s times)\n" "$name" "$count"
            find -- * -type d -name "$name"
        done

}
#@end_function

#@begin_function Zlist
function Zlist() {
    if [ -n "$1" ]; then
        zfs list "$1"
        zfs list -t snapshot "$1"
    fi

    # one-liner
    # { [ -n "$1" ] && zfs list "$1" && zfs list -t snapshot "$1"; }
}
#@end_function

#@begin_function command_exists
function command_exists() {
    local cmd="$1"

    if [[ $# -eq 0 ]]; then
        echo "Usage: command_exists <command>" >&2
        return 2
    fi

    if command -v "$cmd" > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}
#@end_function