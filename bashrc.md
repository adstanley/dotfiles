

## ANSI color codes using tput

```bash
# Breaks line feed for some reason
## ANSI Escape Codes
# Colors
BLACK=$(tput setaf 0)   # \033[1;30m - Black
RED=$(tput setaf 1)     # \033[1;31m - Red
GREEN=$(tput setaf 2)   # \033[1;32m - Green
YELLOW=$(tput setaf 3)  # \033[1;33m - Yellow
BLUE=$(tput setaf 4)    # \033[1;34m - Blue
PURPLE=$(tput setaf 5)  # \033[1;35m - Purple (Magenta)
CYAN=$(tput setaf 6)    # \033[1;36m - Cyan
WHITE=$(tput setaf 7)   # \033[1;37m - White
RESET=$(tput sgr0)      # \033[0m - Reset all attributes
```

## Old code snippet

```bash

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

## "bat" as manpager
if command -v bat >/dev/null 2>&1; then
    export MANPAGER="bat"
    # export MANPAGER="nvim -c 'set ft=man' -"
else
    export MANPAGER="less"
fi

## Add to PATH
if [ -d "$HOME/.bin" ]; then
    PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# if using multiple files for bashrc
if [ -f "$HOME/.bash_directory" ]; then
    source "$HOME/.bash_directory"
fi

# Source custom completion scripts
if [ -d "${HOME}"/.bash_completion.d ]; then
    for file in "${HOME}"/.bash_completion.d/* ; do
        source "$file"
    done
fi

## Bash history
HISTCONTROL=ignoredups:erasedups    # don't put duplicate lines in the history.
HISTSIZE='INFINITE'                 # set history length, non integer values set history to infinite
HISTFILESIZE='STONKS'               # set file size, non integer values set history to infinite
HISTTIMEFORMAT="%F %T "             # set history time format, %F = full date, %T = time
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
    export XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z "$XDG_DATA_HOME" ]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi
if [ -z "$XDG_CACHE_HOME" ]; then
    export XDG_CACHE_HOME="$HOME/.cache"
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
RESET="\[$(tput sgr0)\]"    # Reset

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
# export GCC_COLORS="error=${RED//\\\[/}:warning=${PURPLE//\\\[/}:note=${CYAN//\\\[/}:caret=${GREEN//\\\[/}:locus=${WHITE//\\\[/}:quote=${YELLOW//\\\[/}"
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

# set variable identifying the chroot you work in (used in the prompt below)
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

# Find Aliases
alias dupebyname='find -- * -maxdepth 0 -type d | cut -d "." -f 1,2,3,4,5 | uniq -c' # Find duplicate directories by name

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
alias exa='exa -lahg --color=always --icons --group-directories-first'
alias ls='exa -lahg --color=always --icons --group-directories-first' # list all files colorized in long format

# Directory Shortcuts
alias flatten='find * -type f -exec mv '{}' . \;' # Flatten directory structure
alias getfiles="find -- * -type f"                # Find all files in the current directory
alias extensions="find -- * -type f | sed -e 's/.*\.//' | sed -e 's/.*\///'" # Find all file extensions in the current directory

# Chown Shortcuts
alias ownroot='chown -R -v root:root ./' # chown root recursively
alias mod770='chmod -R -v 755 ./'        # chmod 755 recursively

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

# get held snapshots
# alias holds="zfs get -Ht snapshot userrefs | grep -v $'\t'0 | cut -d $'\t' -f 1 | tr '\n' '\0' | xargs -0 zfs holds"
alias snapshot='zfs list -t snapshot'
alias snapshot1='zfs list -H -o name -t snapshot'

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# adding flags
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

## Git
function git() {
    if [ "$1" = "clone" ]; then
        shift 1
        command git clone --depth=1 "$@"
    else
        command git "$@"
    fi
}

# Move Check
function mv_check() {

    # Function for checking syntax of mv command
    # sort of verbose dry run
    # NOTE !!! this doesn't support the -t flag
    # maybe it will in future (?)

    # check number of arguments
    if [ $# -ne 2 ]; then
        echo "<<< ERROR: must have 2 arguments , but $# given " >&2
        return 1
    fi

    # check if source item exist
    if ! readlink -e "$1" >/dev/null; then
        echo "<<< ERROR: " "$1" " doesn't exist" >&2
        return 1
    fi

    # check where file goes

    if [ -d "$2" ]; then
        echo "Moving " "$1" " into " "$2" " directory"
    else
        echo "Renaming " "$1" " to " "$2"
    fi
}

# Move Function
function rclonemove() {
    # check if input is empty
    if [ -z "$1" ]; then
        printf "Input is empty\n" >&2
        return 1
    fi

    # check number of arguments
    if [ $# -ne 2 ]; then
        printf "<<< ERROR: must have 2 arguments , but %s given.\n" "$#" >&2
        return 1
    fi

    # check if source item exist
    if ! readlink -e "$1" >/dev/null; then
        printf "<<< ERROR: \"%s\" doesn't exist.\n" "$1" >&2
        return 1
    fi

    # check destination
    if [ -d "$2" ]; then
        printf "Destination \"%s\" exists, moving \"%s\" into \"%s\".\n" "$2" "$1" "$2"
    else
        printf "Destination \"%s\" doesn't exist, creating directory \"%s\".\n" "$2" "$2"
    fi

    rclone move -P "$1" "$2"
}

# Copy Function
function rclonecopy() {
    # check if input is empty
    if [ -z "$1" ]; then
        printf "Input is empty\n" >&2
        return 1
    fi
    # check number of arguments
    if [ $# -ne 2 ]; then
        printf "<<< ERROR: must have 2 arguments , but %s given.\n" "$#" >&2
        return 1
    fi

    # check if source item exist
    if ! readlink -e "$1" >/dev/null; then
        printf "<<< ERROR: \"%s\" doesn't exist.\n" "$1" >&2
        return 1
    fi

    # check destinatino
    if [ -d "$2" ]; then
        printf "Destination \"%s\" exists, moving \"%s\" into \"%s\".\n" "$2" "$1" "$2"
    else
        printf "Destination \"%s\" doesn't exist, creating directory \"%s\".\n" "$2" "$2"
    fi

    rclone copy -P "$1" "$2"
}

# Function to find largest files in the current directory
function find_largest_files() {
    du -h -x -s -- * | sort -r -h | head -20;
}

# Function to backup file by appending .bk to the end of the file name
function bk() {
    cp "$1" "$1_$(date +"%Y-%m-%d_%H-%M-%S")".bk
}

# Function to convert hex to Asciic
function hexToAscii() {
    printf "\x%s" "$1"
}

#
function c2f() {
    fc -lrn | head -1 >>"${1?}"
}

# Get history
function hist() {
    history | grep "$1"
}

function findd() {
    printf "Searching for *%s*. \n" "$1"
    find -- * -iname "*$1*" -type d
}

function findf() {
    printf "Searching for *%s*. \n" "$1"
    find -- * -iname "*$1*" -type f
}

function findoutside() {
    find -- * -not -path "./{$1} {$2}/*" -not -path "./_{$1}.{$2}" -not -path "./Lexi Luna "-type d -iname "*{$1}*{$2}*"
}

# Function to extract rar files from incomplete or broken NZB downloads
function packs() {
    printf "extracting rar volumes with out leading zeros.\n"
    { unrar e '*part1.rar' >/dev/null; } 2>&1 # capture stdout and stderr, redirect stderr to stdout and stdout to /dev/null
    printf "extracting rar volumes with leading zeros.\n"
    { unrar e '*part01.rar' >/dev/null; } 2>&1 # capture stdout and stderr, redirect stderr to stdout and stdout to /dev/null
}

# Simple function to identify the type of compression used on a file and extract accordingly
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

### ARCHIVE EXTRACTION
# usage: ex <file>
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
        #*.7z) 7zz x "$1" ;;
        *.deb) ar x "$1" ;;
        *.tar.xz) tar xf "$1" ;;
        *.tar.zst) unzstd "$1" ;;
        *) echo "'$1' cannot be extracted via ex()" ;;
        esac
    fi
}

# navigation
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

function printargs() {
    for ((i = 1; i <= $#; i++)); do
        printf "Arg %d: %s\n" "$i" "${!i}"
    done
}

# Define the function to show ZFS holds
function holds() {
    zfs get -Ht snapshot userrefs | grep -v $'\t'0 | cut -d $'\t' -f 1 | tr '\n' '\0' | xargs -0 zfs holds
}

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
    #if output=$(zfs list -o space -t snapshot -r "$1" | sort -k3 --human-numeric-sort 2>&1); then
    if output=$(zfs list -H -o space -t snapshot -r "$1" | sort -k3 --human-numeric-sort 2>&1); then
        printf "%s\n" "$output"
    else
        printf "Error: %s\n" "$output" >&2
        return 3
    fi

}

# Function to find all file extensions in the current directory
function extensions() {
    # Check if the directory is empty
    if [ -d "$PWD" ]; then
        printf "Directory is empty\n" >&2
        return 1
    fi

    find -- * -type f | sed -e 's/.*\.//' | sed -e 's/.*\///' | sort | uniq -c | sort -rn
}

# Takes a alias name and gets the last command from the history. Makes it an
# alias and puts it in .bash_aliases. Be sure to source .bash_aliases in .bashrc
# or this wont work.
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

function flatten() {
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

abc() {
    local n=$1
    local m=$2
    shift 2
    # It's good to log or echo the command for debugging; ensure to quote "$@" to handle spaces correctly.
    args_string="$n $m $*"
    echo "xyz -n '$n' -m '$m' $args_string"
    # Properly quote "$@" to ensure all arguments are passed correctly to the xyz command.
    xyz -n "$n" -m "$m" "$@"
}

function nested() {
    find "$(pwd)" -type d | awk -F'/' '{print $NF}' | sort | uniq -cd
}

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

function Zlist() { [ -n "$1" ] && zfs list "$1" && zfs list -t snapshot "$1"; }

function Zlist2() {
    if [ -n "$1" ]; then
        zfs list "$1"
        zfs list -t snapshot "$1"
    fi
}

```