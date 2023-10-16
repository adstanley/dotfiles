###########################################################
#  ____ ___ ____ __  __    _    ____ _   _    _    ____   #
# / ___|_ _/ ___|  \/  |  / \  / ___| | | |  / \  |  _ \  #
# \___ \| | |  _| |\/| | / _ \| |   | |_| | / _ \ | | | | #
#  ___) | | |_| | |  | |/ ___ \ |___|  _  |/ ___ \| |_| | #
# |____/___\____|_|  |_/_/   \_\____|_| |_/_/   \_\____/  #
#                                            Chet Manley  #
#                            http://github.com/adstanley  #
#                                    http://sigmachad.io  #
###########################################################
#
# Bashrc
# Shellcheck Directvies
# shellcheck shell=bash
# shellcheck disable=SC1090
# shellcheck disable=SC1091
#
# 1. Environmental Variables / Bash Options
# 2. Aliases
# 3. Functions
#

#################################################################################
# Options                                                                       #
#################################################################################

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## "less" as manpager
export MANPAGER="less"

## "nvim" as manpager
# export MANPAGER="nvim -c 'set ft=man' -"

## "bat" as manpager
# export MANPAGER="bat"

## Prompt
# This is commented out if using starship prompt
# PS1='[\u@\h \W]\$ '

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

## Path
if [ -d "$HOME/.bin" ]; then
    PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

## TrueNAS Specific
# Export path to Heavyscript, default configuration using heavyscript deploy.sh
if [ -d "$HOME/bin" ]; then
    export PATH=/root/bin:${PATH}
fi

## Set Bash Options
# Set No Clobber
set -o noclobber

## Bash history
# don't put duplicate lines in the history.
HISTCONTROL=ignoredups:erasedups
# set history length, non integer values set history to infinite
HISTSIZE='INFINITY'
# set file size, non integer values set history to infinite
HISTFILESIZE='ANDBEYOND'
# set history time format, %F = full date, %T = time
HISTTIMEFORMAT="%F %T "
# append to the history file, don't overwrite it
shopt -s histappend
# try to save all lines of a multiple-line command in the same history entry
shopt -s cmdhist

## Shell Options
shopt -s autocd         # change to named directory
shopt -s cdspell        # autocorrects cd misspellings
shopt -s cmdhist        # save multi-line commands in history as single line
shopt -s dotglob        # include hidden files in globbing
shopt -s histappend     # do not overwrite history
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize   # checks term size when bash regains control
shopt -s extglob        # extended pattern matching
#shopt -s globstar # recursive globbing
# set -o vi # set vi mode

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

# Set Colors
GREEN="\[\033[38;5;2m\]"
YELLOW="\[\033[38;5;11m\]"
BLUE="\[\033[38;5;6m\]"
RESET="\[$(tput sgr0)\]"
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
if [ -f ~/.bash_directory ]; then
    . ~/.bash_directory
fi
alias flatten='find * -type f -exec mv '{}' . \;' # Flatten directory structure
alias getfiles="tree -ifF | grep -v /$ | sed 's/.$//' | sed 's/^[^\/]*\///'"

# Chown Shortcuts
alias ownroot='chown -R -v root:root ./' # chown root recursively
alias mod770='chmod -R -v 755 ./'        # chmod 755 recursively

# k3s Shortcuts
alias pods='k3s kubectl get pods --all-namespaces'
alias showfailed='systemctl list-units --state failed'
alias namespaces='k3s kubectl get namespaces'
alias rename='mv'

# Rclone / Rsync progress
alias cpv='rsync -ah --info=progress2'

# Truetool script Shortcut
alias truetool='bash ~/truetool/truetool.sh'

## ZFS Aliases

# iostat
alias iostat='zpool iostat -vly 5 1'
alias zdb='zdb -U /data/zfs/zpool.cache'

# get held snapshots
alias holds="zfs get -Ht snapshot userrefs | grep -v $'\t'0 | cut -d $'\t' -f 1 | tr '\n' '\0' | xargs -0 zfs holds"
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
git() {
    if [ "$1" = "clone" ]; then
        shift 1
        command git clone --depth=1 "$@"
    else
        command git "$@"
    fi
}

# Move Check
mv_check() {

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

rclonemove() {
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

rclonecopy() {
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

# Function to backup file by appending .bk to the end of the file name
bk() {
    cp "$1" "$1_$(date +"%Y-%m-%d_%H-%M-%S")".bk
}

# Function to convert hex to Asciic
hexToAscii() {
    printf "\x%s" "$1"
}

#
c2f() {
    fc -lrn | head -1 >>"${1?}"
}

#
hist() {
    history | grep "$1"
}

# Function to extract rar files from incomplete or broken NZB downloads
packs() {

    printf "extracting rar volumes with out leading zeros.\n"
    { unrar e '*part1.rar' >/dev/null; } 2>&1 # capture stdout and stderr, redirect stderr to stdout and stdout to /dev/null
    printf "extracting rar volumes with leading zeros.\n"
    { unrar e '*part01.rar' >/dev/null; } 2>&1 # capture stdout and stderr, redirect stderr to stdout and stdout to /dev/null
}

findd() {

    printf "Searching for *%s*. \n" "$1"
    find -- * -iname "*$1*" -type d
}

findf() {

    printf "Searching for *%s*. \n" "$1"
    find -- * -iname "*$1*" -type f
}

# Simple function to identify the type of compression used on a file and extract accordingly
extract() {
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
ex() {
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
        *.7z) 7z x "$1" ;;
        *.deb) ar x "$1" ;;
        *.tar.xz) tar xf "$1" ;;
        *.tar.zst) unzstd "$1" ;;
        *) echo "'$1' cannot be extracted via ex()" ;;
        esac
    fi
}

# navigation
up() {
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

printargs() {
    for ((i = 1; i <= $#; i++)); do
        printf "Arg %d: %s\n" "$i" "${!i}"
    done
}

deleteSnapshots() {
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

getSnapshots() {
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
