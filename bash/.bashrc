###########################################################
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
#################################################################################
#                       Change to Modular Structure                             #
#################################################################################
# Declare associative array for function help
declare -A FUNCTION_HELP

# Source modular files
# for file in ~/.bash_{envs,init,shell,prompt,functions,aliases}; do
#     [ -r "$file" ] && . "$file"
# done
# unset file
#
#################################################################################
#                       Environmental Variables                                 #
#################################################################################

## If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Add to PATH first
if [ -d "${HOME}/.bin" ]; then
    PATH="${HOME}/.bin:$PATH"
fi

if [ -d "${HOME}/.local/bin" ]; then
    PATH="${HOME}/.local/bin:$PATH"
fi

# add appimage directory to path
if [ -d "$HOME/.appimage" ]; then
    PATH="$HOME/.appimage:$PATH"
fi

# Figure out if bat or batcat is installed, if not fall back on cat
function get_bat_command() {
    local commands=("batcat" "bat")
    for cmd in "${commands[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            echo "$cmd"
            return 0
        fi
    done

    # fallback on cat
    echo "cat"
    # 'set filetype to man, - to read from stdin'
    # export MANPAGER="nvim -c 'set ft=man' -"
}

## "bat" as manpager
if command -v batcat >/dev/null 2>&1; then
    MANPAGER=$(get_bat_command)
    export MANPAGER
else
    export MANPAGER="less"
fi

## nvim as default editor
if command -v batcat >/dev/null 2>&1; then
    export EDITOR="nvim"
else
    export EDITOR="nano"
fi

if [ -z "$XDG_CONFIG_HOME" ]; then
    export XDG_CONFIG_HOME="${HOME}/.config"
fi

if [ -z "$XDG_DATA_HOME" ]; then
    export XDG_DATA_HOME="${HOME}/.local/share"
fi

if [ -z "$XDG_CACHE_HOME" ]; then
    export XDG_CACHE_HOME="${HOME}/.cache"
fi

if [ -z "$XDG_STATE_HOME" ]; then
    export XDG_STATE_HOME="${HOME}/.local/state"
fi

#################################################################################
#####                             LS/EXA ETC                                #####
#################################################################################

# Figure out if eza or exa is installed, if not fall back on ls
get_ls_command() {
    local commands=("eza" "exa")
    for cmd in "${commands[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            echo "$cmd"
            return 0
        fi
    done

    # fallback on ls
    echo "ls"
}

LS_COMMAND=$(get_ls_command)

#################################################################################
#####                             HISTORY OPTIONS                           #####
#################################################################################

## Bash history
HISTCONTROL=ignoredups:erasedups                 # don't put duplicate lines in the history.
HISTSIZE='INFINITE'                              # set history length, non integer values set history to infinite
HISTFILESIZE='STONKS'                            # set file size, non integer values set history to infinite
HISTTIMEFORMAT="%F %T "                          # set history time format, %F = full date, %T = time
HISTFILE="${HOME}/.bash_history"                 # set history file location
HISTIGNORE="&:ls:[bf]g:exit:cd*\`printf*\\0057*" # ignore these midnight commander entries

shopt -s histappend # append to the history file, don't overwrite it
shopt -s cmdhist    # try to save all lines of a multiple-line command in the same history entry

# Backup history file
# cp "${HISTFILE}" "${HISTFILE}.bak"

#################################################################################
#####                          SHELL OPTIONS                                #####
#################################################################################

# Set options
set -o noclobber        # Prevent overwriting files
# set -o vi             # Set vi mode, Allows for vi keybindings in the terminal

# Shopt Options
shopt -s autocd         # change to named directory
shopt -s cdspell        # autocorrects cd misspellings
shopt -s dotglob        # include hidden files in globbing
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize   # checks term size when bash regains control
shopt -s extglob        # extended pattern matching
shopt -s globstar       # recursive globbing
shopt -s histverify     # show command with history expansion to allow editing
shopt -s nullglob       # null globbing, no match returns null

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
RESET='\[\033[0m\]'         # Reset

# Text Attributes
BOLD='\033[01m'             # Bold ANSI escape code
UNDERLINE='\033[04m'        # Underline ANSI escape code
ITALIC='\033[03m'           # Italic ANSI escape code

# Colored GCC warnings and errors
# Errors will be displayed in bold red
# Warnings will be displayed in bold purple
# Notes will be displayed in bold cyan
# Carets will be displayed in bold green
# Locus will be displayed in bold white
# Quotes will be displayed in bold yellow
# export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GCC_COLORS="error=${BOLD};${RED//\\\[/}:warning=${BOLD};${PURPLE//\\\[/}:note=${BOLD};${CYAN//\\\[/}:caret=${BOLD};${GREEN//\\\[/}:locus=${BOLD}:quote=${BOLD};${YELLOW//\\\[/}"

# Only check once if git is available, then set a flag.
if command -v git >/dev/null 2>&1; then
    __GIT_AVAILABLE=1
else
    __GIT_AVAILABLE=0
fi

function git_prompt() {
    local COLOR_GIT_CLEAN=$'\033[0;32m'     # Green for clean status
    local COLOR_GIT_STAGED=$'\033[0;33m'    # Yellow for staged changes
    local COLOR_GIT_MODIFIED=$'\033[0;31m'  # Red for unstaged/untracked changes
    local COLOR_RESET=$'\033[0m'            # Reset color

    # Check if git is installed
    if ! command -v git >/dev/null 2>&1; then
        return
    fi

    # Check if in a git repository
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        return
    fi

    # Try to get tag name first
    local ref
    ref=$(git describe --tags --exact-match 2>/dev/null)

    # If no tag, get branch name
    if [ -z "$ref" ]; then
        ref=$(git symbolic-ref -q HEAD 2>/dev/null)
        ref=${ref##refs/heads/}
        ref=${ref:-HEAD}
    fi

    # If no branch, get commit hash
    if [ "$ref" = "HEAD" ]; then
        ref=$(git rev-parse --short HEAD 2>/dev/null)
    fi

    # If no commit hash, set ref to "unknown"
    if [ -z "$ref" ]; then
        ref="unknown"
    fi

    # Check git status
    local status_output
    status_output=$(git status 2>/dev/null)

    # If status is clean, show green
    if [[ $status_output = *"nothing to commit"* ]]; then
        printf " %s[%s]%s" "${COLOR_GIT_CLEAN}" "${ref}" "${COLOR_RESET}"
    # If there are staged changes, show yellow
    elif [[ $status_output = *"Changes to be committed"* ]]; then
        printf " %s[%s*]%s" "${COLOR_GIT_STAGED}" "${ref}" "${COLOR_RESET}"
    # If there are unstaged changes or untracked files, show red
    else
        printf " %s[%s*]%s" "${COLOR_GIT_MODIFIED}" "${ref}" "${COLOR_RESET}"
    fi
}

# Set Prompt
PS1="${debian_chroot:+(${debian_chroot})}${YELLOW}\u${RESET}@${GREEN}\h${RESET}:${BLUE}[\w]${RESET}\$(git_prompt) > ${RESET}"

## Change title of terminals
case ${TERM} in
    xterm* | rxvt* | Eterm* | aterm | kterm | gnome* | alacritty | st | konsole*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;

    screen*)
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
        ;;
esac

# IDK man left it in from the default bashrc
# If using debian, set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# IDK man left it in from the default bashrc
# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f "/usr/share/bash-completion/bash_completion" ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f "/etc/bash_completion" ]; then
        . /etc/bash_completion
    fi
fi

# Source custom completion scripts from .bash_completion.d
# if .bash_completion.d exists
if [ -d "${HOME}/.bash_completion" ]; then
    for file in "${HOME}"/.bash_completion/* ; do
        source "$file"
    done
fi

# SSH Agent
# Check if ssh agent is running, if not start ssh agent and add .ssh keys
# Only start agent if there is an .ssh folder
if [ ! -d "$HOME/.ssh" ]; then
    if [ -z "$SSH_AUTH_SOCK" ]; then
        # Start the ssh-agent in the background
        eval "$(ssh-agent -s)" >/dev/null 2>&1

        # Add all keys in ~/.ssh except for known_hosts and config
        readarray -t ssh_keys < <(find ~/.ssh -type f -not -iname "*.pub" -not -name "known_hosts" -not -name "config")

        for key in "${ssh_keys[@]}"; do
            ssh-add "$key" 2>/dev/null
        done
    fi
fi

#################################################################################
#                                    Help                                       #
#################################################################################

#@Name: handle_help
#@Description: Display help message for a given function using FUNCTION_HELP array
#@Arguments: [function_name] [--help|-h]
#@Usage: handle_help <function_name> [--help|-h]
#@define help information
FUNCTION_HELP[handle_help]=$(cat << 'EOF'
NAME
    handle_help - Display help message for a given function

DESCRIPTION
    Checks if the second argument is --help or -h and prints the help message
    stored in the FUNCTION_HELP associative array for the specified function name.

USAGE
    handle_help <function_name> [--help|-h]

OPTIONS
    <function_name> : Name of the function to display help for
    --help, -h      : Show this help message and exit

EXAMPLES
    handle_help cd_drive --help
        Prints the help message for the cd_drive function.
EOF
)
#@begin_function
handle_help() {
    local func_name="$1"
    shift
    local verbose=false
    if [[ "$1" == "--verbose" || "$1" == "-v" ]]; then
        verbose=true
        shift
    fi
    if [[ -z "$func_name" ]]; then
        printf "Error: No function name provided to handle_help\n" >&2
        return 3
    fi
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[$func_name]}" ]]; then
            echo "${FUNCTION_HELP[$func_name]}"
            if [[ "$verbose" == true ]]; then
                echo -e "\nFunction definition:"
                type "$func_name"
            fi
            return 0
        else
            printf "Help not available for function: %s\n" "$func_name" >&2
            return 2
        fi
    fi
    return 1
}
#@end_function

list_functions() {
    printf "Available functions with help:\n"
    for func in "${!FUNCTION_HELP[@]}"; do
        printf "%s\n" "$func"
    done | sort
}

#################################################################################
#                                    Aliases                                    #
#################################################################################

# Some aliases are functions
# nvim is an alias to nvim.appimage if it exists

# Filesystem Shortcuts
#@Name: cd_drive
#@Description: Change directory to a specified drive
#@Arguments: [directory]
#@Usage: cd_drive [directory]
#@define help information
FUNCTION_HELP[cd_drive]=$(cat << 'EOF'
NAME
    cd_drive - Change directory to a specified drive

DESCRIPTION
    Change the current directory to a specified drive. If the directory does not exist, an error message is printed.

USAGE
    cd_drive [DIRECTORY]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function
cd_drive() {

    local dir="$1"
    handle_help "${FUNCNAME[0]}" "$@" && return 0

    if [[ -d "$dir" ]]; then
        cd "$dir" || { printf "Failed to change to %s\n" "$dir"; return 1; }
    else
        printf "Directory %s does not exist\n" "$dir"
        return 1
    fi
}
#@end_function

alias resetcursor='printf \e[5 q'

# Directory shortcuts
alias cd_sab='cd_drive /mnt/spool/SABnzbd/Completed'
alias cd_torrent='cd_drive /mnt/spool/torrent'

# Drive shortcuts
alias cd_toshiba='cd /mnt/toshiba'
alias cd_toshiba2='cd /mnt/toshiba2'
alias cd_toshiba3='cd /mnt/toshiba3'
alias cd_toshiba4='cd /mnt/toshiba4'
alias cd_spool='cd /mnt/spool'
alias cd_spool-temp='cd /mnt/spool/temp'
alias cd_mach2='cd /mnt/mach2'
alias cd_seagatemirror='cd /mnt/seagatemirror'
alias cd_pron='cd /mnt/z2pool/Pr0n'

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

# Exa alias settings (Moved to function)
# alias eza='eza --all --long --header --git --icons --group-directories-first --color=always'

# Directory Shortcuts
alias getfiles="find -- * -type f" # Find all files in the current directory
# alias extensions="find -- * -type f | sed -e 's/.*\.//' | sed -e 's/.*\///'" # Moved to Functions

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
alias psuser='ps auxf | sort -nr -k 1'

# get diskspace
alias diskspace="du -S | sort -n -r | less" # get disk space sorted by size piped to less
alias df='df -h'
alias du='du -hs'
alias free='free -m'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

#################################################################################
#                                    Functions                                  #
#################################################################################

#@Name: show_help
#@Description: Handle help requests for functions
#@Arguments: [--help|-h]
#@Usage: show_help [--help|-h]
#@define help information
FUNCTION_HELP[show_help]=$(cat << 'EOF'
NAME
    show_help - Handle help requests for functions
DESCRIPTION
    This function checks if the first argument is --help or -h and prints the help message for the calling function.
    If no help message is available, it prints an error message.
USAGE
    show_help [--help|-h]
OPTIONS
    --help, -h
        Show this help message and exit.
EXAMPLES
    show_help --help
        Prints the help message for the calling function.
    show_help -h
        Prints the help message for the calling function.
EOF
)
#@begin_function
show_help() {
    local callback="${FUNCNAME[1]}"
    
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[$callback]}" ]]; then
            echo "${FUNCTION_HELP[$callback]}"
        else
            echo "Help not available for function: $callback" >&2
            return 2
        fi
        return 0
    fi
    return 1
}

#@Name: example
#@Description: example function
#@Arguments: None
#@Usage: example
#@define help information
FUNCTION_HELP[example]=$(cat << 'EOF'
NAME
    function_name - Short description of the function

DESCRIPTION
    A longer description of the function, explaining what it does and how to use it.

USAGE
    function_name [OPTIONS]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function
function example() {
    #####################
    # Pick One
    #####################
    # Direct help check
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    # Indirect help check
    handle_help "$@" && return 0
    #####################
    
    # Example function code here
    echo "This is an example function."
}
#@end_function

#@Name: zfs_alias
#@Description: Create functions to change directory to ZFS mountpoints
#@Arguments: None
#@Usage: zfs_alias
#@define help information
FUNCTION_HELP[zfs_alias]=$(cat << 'EOF'
NAME
    zfs_alias - Create functions to change directory to ZFS mountpoints

DESCRIPTION
    Create functions to change directory to ZFS mountpoints.

USAGE
    zfs_alias [OPTIONS]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES
    zfs_alias
        Create functions to change directory to ZFS mountpoints.
    zfs_alias --help
        Show this help message and exit.

EOF
)
#@begin_function
zfs_alias() {
    # Check if the first argument is --help or -h
    # If so, print the help message and exit
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    # Create a temporary file using shell builtins
    local tmp_file="/tmp/zfs_alias_$$.tmp"  # $$ is the process ID
    
    # Get list of pools
    mapfile -t pools < <(zpool list -H -o name)
    
    # Write function definitions to the temporary file
    for pool in "${pools[@]}"; do
        mountpoint=$(zfs get -H mountpoint "$pool" | awk '{print $3}')
        if [[ "$mountpoint" != "none" ]]; then
        echo "cd.$pool() { cd \"$mountpoint\" || exit; }" >> "$tmp_file"
        fi
    done
    
    # Source the file to define the functions
    source "$tmp_file"
    
    # Clean up
    rm "$tmp_file"
}
#@end_function

# Only call the function if zfs-utils are installed
# if command -v zpool > /dev/null 2>&1 && zpool list > /dev/null 2>&1; then
#   zfs_alias "$@"
# fi

#@Name: nvim
#@Description: Launch best available Neovim installation
#@Usage: nvim [options] [files...]
FUNCTION_HELP[nvim]=$(cat << 'EOF'
NAME
    nvim - Launch best available Neovim installation
DESCRIPTION
    Automatically finds and launches the best Neovim installation:
    1. AppImage in ~/.appimage/
    2. Locally compiled nvim in common paths
    3. System package nvim
USAGE
    nvim [OPTIONS] [FILE]...
EXAMPLES
    nvim file.txt
    nvim --version
EOF
)

#@begin_function
nvim() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    # Cache the nvim path to avoid repeated searches
    if [[ -z "$NVIM_PATH" ]]; then
        # Priority order: AppImage, local compile, system package
        local candidates=(
            /usr/local/bin/nvim
            "$HOME/.local/bin/nvim"
            "$HOME/.appimage/nvim.appimage"
            "$HOME/.bin/nvim"
        )
        
        for candidate in "${candidates[@]}"; do
            if [[ -x "$candidate" ]]; then
                export NVIM_PATH="$candidate"
                break
            fi
        done
        
        # Fallback to system nvim
        if [[ -z "$NVIM_PATH" ]] && command -v nvim >/dev/null 2>&1; then
            NVIM_PATH="$(command -v nvim)"
            export NVIM_PATH
        fi
        
        if [[ -z "$NVIM_PATH" ]]; then
            printf "Error: No Neovim installation found\n" >&2
            return 1
        fi
    fi
    
    "$NVIM_PATH" "$@"
}
#@end_function

nvim_reset() {
    unset NVIM_PATH
    echo "Neovim path cache cleared"
}

#@name ls
#@description Determine if eza or ls should be used
#@usage ls
#@define help information
FUNCTION_HELP[ls]=$(cat << 'EOF'
NAME
    ls - list directory contents

DESCRIPTION
    List information about files and directories, using eza if available.

USAGE
    ls [OPTIONS] [FILE]...

OPTIONS
    Same options as eza or ls depending on which is available.
    Add --help or -h to see this help message.

EXAMPLES
    ls -la ~/Documents
EOF
)
#@begin_function
function ls() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    if [ "$LS_COMMAND" = "eza" ]; then
        eza --all --long --header --git --icons --group-directories-first --color=always "$@"
    elif [ "$LS_COMMAND" = "exa" ]; then
        exa --all --long --header --git --icons --group-directories-first --color=always "$@"
    elif [ "$LS_COMMAND" = "ls" ]; then
        command ls -lahg --color=always --group-directories-first "$@"
    fi
}
#@end_function

#@name cdir
#@description cd into the last files directory
#@usage cdir
#@example cdir
#@define help information
FUNCTION_HELP[cdir]=$(cat << 'EOF'
NAME
    cdir - change directory to the last file's directory
DESCRIPTION
    Change the current directory to the directory of the last file used in the command line.
USAGE
    cdir
EXAMPLES
    cdir
EOF
)
#@begin_function
function cdir() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    cd "${_%/*}" || return
}

#@Name: countfields
#@Description: Count the number of fields in a directory name
#@Arguments: [directory]
#@Usage: countfields [directory] 
#@define help information
FUNCTION_HELP[countfields]=$(cat << 'EOF'
NAME
    countfields - Count the number of fields in a directory name
DESCRIPTION
    Count the number of fields in a directory name, separated by dots.
    This is useful for identifying the number of fields in a directory name.
USAGE
    countfields [DIRECTORY]
EXAMPLES
    countfields /path/to/directory
    countfields .
    countfields *
EOF
)
#@begin_function countfields
function countfields() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    # if $1 is empty, use "*"
    local target_dir="${1:-*}"

    find -- "$target_dir" -maxdepth 0 -type d | awk -F"." '{print NF, $0}' | sort -nr | uniq -c
}
#@end_function


#@Name: dupebyname
#@Description: This is an example function
#@Usage: dupebyname [argument]
#@define help information
FUNCTION_HELP[dupebyname]=$(cat << 'EOF'
NAME
    example - This is an example function
USAGE
    dupebyname [DIRECTORY]
EXAMPLES
    dupebyname /path/to/directory
    dupebyname .
    dupebyname *
EOF
)  
#@begin_function dupebyname
function dupebyname() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    find -- * -maxdepth 0 -type d | cut -d "." -f 1,2,3,4,5 | uniq -c
}
#@end_function


#@Name: ownroot
#@Description: Change ownership to root
#@Usage: ownroot [directory]
#@define help information
FUNCTION_HELP[ownroot]=$(cat << 'EOF'
NAME
    ownroot - Change ownership to root
USAGE
    ownroot [DIRECTORY]
EXAMPLES
    ownroot /path/to/directory
    ownroot .
EOF
)  
#@begin_function ownroot
function ownroot() {

    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    # "${1:-.}" = if $1 is empty, use current dir "."
    local target_dir="${1:-.}"
    target_dir=$(readlink -f "$target_dir")

    # Check if the target directory exists
    if [ ! -d "$target_dir" ]; then
        printf "Error: %s is not a directory.\n" "$target_dir" >&2
        return 1
    fi
    
    # Prevent modification of critical directories or their subdirectories
    if [[ "$target_dir" == /* || "$target_dir" == /home/* || "$target_dir" == /root/* || "$target_dir" == /etc/* ]]; then
        echo "Error: '$target_dir' is a critical system directory or subdirectory." >&2
        return 1
    fi

    # Sanity Check
    read -rp "Are you sure you want to change ownership of '$target_dir' to root? [y/N] " confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        return 1
    fi

    # Change ownership recursively
    chown -R -v root:root "$target_dir"

    # Set directories to 755
    find "$target_dir" -type d -exec chmod -v 755 {} \;

    # Set folders to 644 idk grok suggested this revisit in future this is stupid anyway
    find "$target_dir" -type f -exec chmod -v 644 {} \;
}
#@end_function


#@Name: mod775
#@Description: modify permissions to 775, will default to current directory
#@Arguments: [directory]
#@Usage: mod775 ./
#@define help information
FUNCTION_HELP[mod775]=$(cat << 'EOF'
NAME
    example - This is an example function
USAGE
    dupebyname [DIRECTORY]
EXAMPLES
    dupebyname /path/to/directory
    dupebyname .
    dupebyname *
EOF
)  
#@begin_function mod775
function mod775() {

    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

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


# Name: git_shallow
# Description: Shallow clone a git repository
# Arguments: [clone] [url]
# Usage: git_shallow clone [url]
#@begin_function git_shallow
function git_shallow() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    if [ "$1" = "clone" ]; then
        shift 1
        command git clone --depth=1 "$@"
    else
        command git "$@"
    fi
}
#@end_function


# Name: git_branch
# Description: Shows current git branch
# Arguments: None
# Usage: git_branch
#@begin_function
function git_branch() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
#@end_function


# Name: mv_check
# Description: Function for checking syntax of mv command
# Arguments: [source] [destination]
# Usage: mv_check [source] [destination]
#@begin_function mv_check
function mv_check() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    # check if -t flag is present as this modifies the number of arguments we expect
    if [ "$1" = "-t" ]; then
        if [ $# -lt 3 ]; then
            printf "<<< ERROR: with -t flag, must have at least 3 arguments, but %s given\n" "$#" >&2
            return 1
        fi

        target_dir="$2"
        shift 2

        # check if target directory exists
        if [ ! -d "$target_dir" ]; then
            printf "<<< ERROR: target directory %s doesn't exist\n" "$target_dir" >&2
            return 1
        fi

        for src in "$@"; do
            if ! readlink -e "$src" >/dev/null; then
                printf "<<< ERROR: %s doesn't exist\n" "$src" >&2
                return 1
            fi
            printf "Moving %s into %s directory\n" "$src" "$target_dir"
        done
        
        # Execute the move command with -t flag
        mv -t "$target_dir" "$@"
        return $?

    else
        # check number of arguments
        if [ $# -ne 2 ]; then
            printf "<<< ERROR: must have 2 arguments, but %d given\n" "$#" >&2
            return 1
        fi

        src="$1"
        dest="$2"

        # check source
        if ! readlink -e "$src" >/dev/null; then
            printf "<<< ERROR: %s doesn't exist\n" "$src" >&2
            return 1
        fi

        # check destination
        if [ -d "$dest" ]; then
            printf "Moving %s into %s directory\n" "$src" "$dest"
        else
            printf "Renaming %s to %s\n" "$src" "$dest"
        fi
        
        # Execute the move command
        mv "$src" "$dest"
        return $?
    fi
}


# Name: rclonemove
# Description: Move files using rclone
# Arguments: [source] [destination]
# Usage: rclonemove [source] [destination]
#@begin_function rclonemove
function rclonemove() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi
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
        
        # Move to a new line
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mkdir -p "$parent_dir"
        else
            printf "Operation cancelled.\n"
            return 1
        fi
    fi

    printf "Moving \"%s\" to \"%s\".\n" "$source" "$destination"
    rclone move -P --ignore-existing --checkers 4 --transfers 4 --order-by size,mixed,75 "$source" "$destination"
}
#@end_function


# Copy Function
#@begin_function rclonecopy
function rclonecopy() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi
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
    handle_help "$@" && return 0

    du -h -x -s -- * | sort -r -h | head -20;
}
#@end_function


# Function to backup file by appending .bk to the end of the file name
#@begin_function bk
function bk() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    cp "$1" "$1_$(date +"%Y-%m-%d_%H-%M-%S")".bk
}
#@end_function


# Function to convert hex to Asciic
#@begin_function hexToAscii
function hexToAscii() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    printf "\x%s" "$1"
}
#@end_function


# idk man
#@begin_function c2f
function c2f() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    fc -lrn | head -1 >>"${1?}"
}
#@end_function


# Get history
#@name hist
#@description Search bash history with colorized output
#@usage hist [search_term]
#@example hist ssh
#@begin_function hist
function hist() {
    handle_help "$@" && return 0

    local color="true"

    if [ -z "$1" ]; then
        history
        return 0
    fi

    if [ $color == "false" ]; then
        history | grep "$1"
        return 0
    else
        history | grep "$1" | awk '
        {
            printf "\033[1;34m%5d\033[0m \033[1;36m%s %s\033[0m \033[1;32m%s\033[0m\n", $1, $2, $3, substr($0, index($0,$4))
        }'
    fi

}
#@end_function

# Create a .7z compressed file with maximum compression
# Example: 7zip "/path/to/folder_or_file" "/path/to/output.7z"
#@begin_function 7zip
function 7zip() { 
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on -mhe=on "$2" "$1" 
}
#@end_function


# Function to extract rar files from incomplete or broken NZB downloads
#@begin_function packs
function packs() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    printf "extracting rar volumes with out leading zeros.\n"
    { unrar e '*part1.rar' >/dev/null; } 2>&1 # capture stdout and stderr, redirect stderr to stdout and stdout to /dev/null
    printf "extracting rar volumes with leading zeros.\n"
    { unrar e '*part01.rar' >/dev/null; } 2>&1 # capture stdout and stderr, redirect stderr to stdout and stdout to /dev/null
}
#@end_function


# Simple function to identify the type of compression used on a file and extract accordingly
#@begin_function extract
function extract() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

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
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

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
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

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
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    for ((i = 1; i <= $#; i++)); do
        printf "Arg %d: %s\n" "$i" "${!i}"
    done
}
#@end_function


# Define the function to show ZFS holds
#@begin_function holds
function holds() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    zfs get -Ht snapshot userrefs | grep -v $'\t'0 | cut -d $'\t' -f 1 | tr '\n' '\0' | xargs -0 zfs holds
}
#@end_function


# Function to create multiple ZFS datasets at once
#@begin_function create_datasets
function create_datasets() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

  local pool_name="$1"
  shift  # Remove the first argument (pool name)
  
  # Check if pool name was provided
  if [ -z "$pool_name" ]; then
    printf "Error: Pool name is required\n"
    printf "Usage: create_datasets <pool_name> <dataset1> <dataset2> ...\n"
    return 1
  fi
  
  # Check if at least one dataset name was provided
  if [ $# -eq 0 ]; then
    printf "Error: At least one dataset name is required\n"
    printf "Usage: create_datasets <pool_name> <dataset1> <dataset2> ...\n"
    return 1
  fi
  
  # Create each dataset
  for ds in "$@"; do
    printf "Creating dataset: %s\n" "$pool_name/$ds"
    zfs create "$pool_name/$ds" && printf "Success\n" || printf "Failed with exit code %s\n" "$?"
  done
}
#@end_function


#@begin_function deletesnapshot
function deletesnapshot() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

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


#@ Name: takesnapshot
#@ Description: Create a ZFS snapshot for a specified dataset
#@ Arguments: <dataset> [snapshot_suffix]
#@ Usage: takesnapshot <dataset> [snapshot_suffix] [--dry-run]
#@ define help information
FUNCTION_HELP[takesnapshot]=$(cat << 'EOF'
NAME
    takesnapshot - Create a ZFS snapshot for a specified dataset
DESCRIPTION
    Create a ZFS snapshot for the specified dataset. If no snapshot suffix is provided, a default suffix of "manual-YYYY-MM-DD_HH-MM-SS" is used.
USAGE
    takesnapshot <dataset> [snapshot_suffix] [--dry-run]
OPTIONS
    <dataset>        : ZFS dataset name (e.g., poolname/dataset)
    [snapshot_suffix]: Optional custom suffix for snapshot name (default: manual-YYYY-MM-DD_HH-MM-SS)
    --dry-run        : Show the snapshot command without executing it
    --help           : Display this help message
EXAMPLES
    takesnapshot poolname/dataset
        Create a snapshot with the default suffix.
    takesnapshot poolname/dataset custom_suffix
        Create a snapshot with a custom suffix.
    takesnapshot --dry-run poolname/dataset
        Show the snapshot command without executing it.
EOF
)
#@begin_function takesnapshot
function takesnapshot_old() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

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

#@ Name: takesnapshot
#@ Description: Create a ZFS snapshot for a specified dataset
#@ Arguments: <dataset> [snapshot_suffix]
#@ Usage: takesnapshot <dataset> [snapshot_suffix] [--dry-run]
#@ define help information
FUNCTION_HELP[takesnapshot]=$(cat << 'EOF'
NAME
    takesnapshot - Create a ZFS snapshot for a specified dataset
DESCRIPTION
    Create a ZFS snapshot for the specified dataset. If no snapshot suffix is provided, a default suffix of "manual-YYYY-MM-DD_HH-MM-SS" is used.
USAGE
    takesnapshot <dataset> [snapshot_suffix] [--dry-run]
OPTIONS
    <dataset>        : ZFS dataset name (e.g., poolname/dataset)
    [snapshot_suffix]: Optional custom suffix for snapshot name (default: manual-YYYY-MM-DD_HH-MM-SS)
    --dry-run        : Show the snapshot command without executing it
    --help           : Display this help message
EXAMPLES
    takesnapshot poolname/dataset
        Create a snapshot with the default suffix.
    takesnapshot poolname/dataset custom_suffix
        Create a snapshot with a custom suffix.
    takesnapshot --dry-run poolname/dataset
        Show the snapshot command without executing it.
EOF
)
#@begin_function takesnapshot
function takesnapshot() {
    # Display help message if --help is provided
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    # Check if zfs command is available
    if ! command -v zfs &> /dev/null; then
        printf "Error: zfs command not found or not installed\n" 1>&2
        return 1
    fi

    # Check if dataset is provided
    if [ -z "$1" ]; then
        printf "Error: No dataset specified\n" 1>&2
        return 2
    fi

    local dataset="$1"
    local snapshot_suffix="${2:-manual-$(date +"%Y-%m-%d_%H-%M-%S")}"
    local dry_run=false

    # Check for dry-run flag
    if [ "$dataset" = "--dry-run" ]; then
        if [ -z "$2" ]; then
            printf "Error: --dry-run requires a dataset\n" 1>&2
            return 2
        fi
        dry_run=true
        dataset="$2"
        snapshot_suffix="${3:-manual-$(date +"%Y-%m-%d_%H-%M-%S")}"
    fi

    # Validate dataset existence
    if ! zfs list "$dataset" &> /dev/null; then
        printf "Error: Dataset '%s' does not exist\n" "$dataset" 1>&2
        return 3
    fi

    # Validate snapshot suffix (if provided)
    if [ -n "$2" ] && [ "$2" != "--dry-run" ] && [[ ! "$snapshot_suffix" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        printf "Error: Invalid snapshot suffix '%s'. Use alphanumeric characters, '_', or '-'\n" "$snapshot_suffix" 1>&2
        return 4
    fi

    local snapshot_name="$dataset@$snapshot_suffix"

    # Perform dry run if requested
    if [ "$dry_run" = true ]; then
        printf "Dry run: Would execute: zfs snapshot %s\n" "$snapshot_name"
        return 0
    fi

    # Create the snapshot
    if output=$(zfs snapshot "$snapshot_name" 2>&1); then
        printf "Snapshot created: %s\n" "$snapshot_name"
        return 0
    else
        printf "Error creating snapshot: %s\n" "$output" 1>&2
        return 6
    fi
}
#@end_function takesnapshot

#@Name: getsnapshot
#@Description: Get a list of snapshots for a given dataset
#@Arguments: <dataset>
#@Usage: getsnapshot <dataset>
#@define help information
FUNCTION_HELP[getsnapshot]=$(cat << 'EOF'
NAME
    function_name - Short description of the function

DESCRIPTION
    A longer description of the function, explaining what it does and how to use it.

USAGE
    function_name [OPTIONS]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function getsnapshot
function getsnapshot() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

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

#@Name: example
#@Description: example function
#@Arguments: None
#@Usage: example
#@define help information
FUNCTION_HELP[example]=$(cat << 'EOF'
NAME
    function_name - Short description of the function

DESCRIPTION
    A longer description of the function, explaining what it does and how to use it.

USAGE
    function_name [OPTIONS]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function getspace
function getspace() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

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

#@Name: findext
#@Description: Find files with a specific extension in the current directory
#@Arguments: <extension>
#@Usage: findext <extension>
#@define help information
FUNCTION_HELP[findext]=$(cat << 'EOF'
NAME
    findext - Find files with a specific extension in the current directory
DESCRIPTION
    Find files with a specific extension in the current directory and its subdirectories.
USAGE
    findext <extension>
OPTIONS
    <extension> : The file extension to search for (e.g., .txt, .jpg)
EXAMPLES
    findext .txt
        Find all files with the .txt extension in the current directory and its subdirectories.
EOF
)
#@begin_function findext
function findext() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    # Check if the input is empty
    if [ -z "$1" ]; then
        printf "Input is empty\n" >&2
        return 1
    fi

    # Find files with the specified extension
    find -- * -type f -name "*$1" -print0 | xargs -0 command ls -lh --color=always
}

function extensions() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    # Check if the directory is empty
    if [ -d "$PWD" ]; then
        printf "Directory is empty\n" >&2
        return 1
    fi

    find -- * -type f | sed -e 's/.*\.//' | sed -e 's/.*\///' | sort | uniq -c | sort -rn
}
#@end_function

#@Name: makeAlias
#@Description: Create a bash alias from the last command in history
#@Arguments: <alias_name>
#@Usage: makeAlias <alias_name>
#@define help information
FUNCTION_HELP[makeAlias]=$(cat << 'EOF'
NAME
    makeAlias - Create a bash alias from the last command in history
DESCRIPTION
    Create a bash alias from the last command in history. The alias will be saved in ~/.bash_aliases.
USAGE
    makeAlias <alias_name>
OPTIONS
    <alias_name> : The name of the alias to create
EXAMPLES
    makeAlias myalias
        Create an alias named 'myalias' from the last command in history.
EOF
)
#@begin_function makeAlias
function makeAlias() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

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

#@Name: example
#@Description: example function
#@Arguments: None
#@Usage: example
#@define help information
FUNCTION_HELP[example]=$(cat << 'EOF'
NAME
    function_name - Short description of the function

DESCRIPTION
    A longer description of the function, explaining what it does and how to use it.

USAGE
    function_name [OPTIONS]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function insertDirectory
function insertDirectory() {

    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        return 0
    fi

    if [ $# -ne 2 ]; then
        printf "Usage: %s <file> <directory>\n" "${FUNCNAME[0]}"
        return 1
    fi

    local filename insert
    filename="$(realpath "$1")" || return 1
    insert="$2"

    # Check if file exists
    if [ ! -e "$filename" ]; then
        printf "File '%s' does not exist.\n" "$filename" >&2
        return 1
    fi

    # Check if insert is a directory
    if [ ! -d "$PWD/$insert" ]; then
        read -rp "Directory '$insert' does not exist. Create Directory? (Y\N) " answer
        if [[ $answer =~ ^[Yy] ]]; then
            mkdir -pv "$insert" || return 1
        else
            printf "Aborting...\n"
            return 1
        fi
    fi

    # Preview change
    printf "Preview: \nMoving:\n%s\nto:\n%s/%s/%s\n\n" "$filename" "$(dirname "$1")" "$insert" "$(basename "$1")"

    # Prompt for confirmation
    read -rp "Continue? (Y\N) " answer
    if [[ $answer =~ ^[Yy] ]]; then
        mv -iv "$filename" "$(dirname "$1")/$insert/$(basename "$1")"
        return 0
    else
        printf "Aborting...\n"
    fi
}
#@end_function


#@Name: flatten
#@Description: flatten subdirectories by moving all files to the current directory
#@Arguments: None
#@Usage: flatten
#@define help information
FUNCTION_HELP[flatten]=$(cat << 'EOF'
NAME
    flatten - Move all files from subdirectories to the current directory

DESCRIPTION
    Move all files from subdirectories to the current directory, avoiding duplicates.

USAGE
    function_name [OPTIONS]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function
function flatten() {
    local -a flatten
    local -a duplicates
    local current_dir
    current_dir=$(pwd)

    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi
    
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

#@Name: remove_empty_dirs
#@Description: Remove empty directories in the specified directory
#@Arguments: None
#@Usage: remove_empty_dirs
#@define help information
FUNCTION_HELP[remove_empty_dirs]=$(cat << 'EOF'
NAME
    remove_empty_dirs - Remove empty directories in the specified directory

DESCRIPTION
    Remove empty directories in the specified directory, prompting for confirmation before deletion.

USAGE
    function_name [OPTIONS]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function
function remove_empty_dirs() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    local current_dir
    current_dir=$(pwd)
    
    target_dir="${1:-$current_dir}"

    if [[ ! -d "$target_dir" ]]; then
        echo "Error: '$target_dir' is not a directory or does not exist." >&2
        exit 1
    fi

    target_dir=$(realpath "$target_dir")

    case "$target_dir" in
        /|/boot|/home|/root|/etc|/var|/usr|/bin|/sbin|/lib|/lib64|/dev|/proc|/sys|/tmp|/opt|/srv|/media|/mnt)
            echo "Error: Refusing to operate in critical directory '$target_dir'." >&2
            exit 1
            ;;
    esac

    echo "Scanning for empty directories in: $target_dir"

    find "$target_dir" -type d -empty -print0 | while IFS= read -r -d '' dir; do
        echo "Found empty directory: $dir"
        read -rp "Delete this directory? [y/N] " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            if rmdir "$dir" 2>/dev/null; then
                echo "Deleted: $dir"
            else
                echo "Failed to delete: $dir (possibly not empty or permission denied)" >&2
            fi
        else
            echo "Skipped: $dir"
        fi
    done

    printf "Done.\n"
}
#@end_function

#@Name: nested
#@Description: Find duplicate directory names in the current directory and its subdirectories
#@Arguments: None
#@Usage: nested
#@define help information
FUNCTION_HELP[nested]=$(cat << 'EOF'
NAME
    nested - Find duplicate directory names in the current directory and its subdirectories
DESCRIPTION
    Find duplicate directory names in the current directory and its subdirectories.
USAGE
    nested
OPTIONS
    None
EXAMPLES
    nested
        Find and list duplicate directory names in the current directory and its subdirectories.
EOF
)
#@begin_function
function nested() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    # Simple version
    # find "$(pwd)" -type d | awk -F'/' '{print $NF}' | sort | uniq -cd

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

#@Name: example
#@Description: example function
#@Arguments: None
#@Usage: example
#@define help information
FUNCTION_HELP[example]=$(cat << 'EOF'
NAME
    function_name - Short description of the function

DESCRIPTION
    A longer description of the function, explaining what it does and how to use it.

USAGE
    function_name [OPTIONS]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function zfs_list
function zfs_list() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    if [ -n "$1" ]; then
        zfs list "$1"
        zfs list -t snapshot "$1"
    fi

    # one-liner
    # { [ -n "$1" ] && zfs list "$1" && zfs list -t snapshot "$1"; }
}
#@end_function

#@Name: example
#@Description: example function
#@Arguments: None
#@Usage: example
#@define help information
FUNCTION_HELP[example]=$(cat << 'EOF'
NAME
    function_name - Short description of the function

DESCRIPTION
    A longer description of the function, explaining what it does and how to use it.

USAGE
    function_name [OPTIONS]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function moveTemplate
function moveTemplate() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

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

#@Name: example
#@Description: example function
#@Arguments: None
#@Usage: example
#@define help information
FUNCTION_HELP[example]=$(cat << 'EOF'
NAME
    function_name - Short description of the function

DESCRIPTION
    A longer description of the function, explaining what it does and how to use it.

USAGE
    function_name [OPTIONS]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function rclone_move
function rclone_move() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    # Check if the input is empty
    if [ -z "$1" ]; then
        printf "Input is empty\n" >&2
        return 1
    fi

    # Check if the input is less than 2 arguments
    if [ $# -lt 2 ]; then
        printf "Error: Must have at least 2 arguments, but %d given.\n" "$#" >&2
        return 1
    fi

    # Check if the rclone command is available
    if ! command -v rclone &>/dev/null; then
        printf "Error: rclone command not found or not installed\n" >&2
        return 1 # Exit with error
    fi

    local src="$1"
    local dest="$2"
    shift 2 # Remove the first two arguments

    # Check if source exists
    if ! src=$(readlink -e "$src"); then
        printf "Error: Source \"%s\" doesn't exist or is not accessible.\n" "$1" >&2
        return 1
    fi
    
    local parent_dir
    parent_dir=$(dirname "$dest")

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

    # Execute the rclone command with the provided arguments
    if output=$(rclone move -P --delete-empty-src-dirs --ignore-existing --checkers 4 --transfers 4 --order-by size,mixed,75 "$src" "$dest" 2>&1); then
        printf "%s\n" "$output"
    else
        printf "Error: %s\n" "$output" >&2
        return 3 # Exit with error
    fi
}
#@end_function

#@Name: copyacl
#@Description: Copy ACLs from source directory to destination directory
#@Arguments: [source] [destination]
#@Usage: copyacl [source] [destination]
#@define help information
FUNCTION_HELP[copyacl]=$(cat << 'EOF'
NAME
    copyacl - Copy ACLs from source directory to destination directory

DESCRIPTION
    This function copies the Access Control Lists (ACLs) from a source directory to a destination directory.
    It ensures that the destination is not a critical system directory and that the source is readable.

USAGE
    copyacl [SOURCE] [DESTINATION]
    If SOURCE is not provided, it defaults to /mnt/spool/SABnzbd/.
    If DESTINATION is not provided, it defaults to the current working directory.

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
#@begin_function
copyacl() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[${FUNCNAME[0]}]}" ]]; then
            echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        else
            echo "Help not available for function: ${FUNCNAME[0]}" >&2
            return 2
        fi
        return 0
    fi

    local source="${1:-/mnt/spool/SABnzbd/}"
    local destination="${2:-$(pwd)}"

    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "${FUNCTION_HELP[${FUNCNAME[0]}]}"
        return 0
    fi
    
    # Resolve destination to absolute path for accurate checking
    destination=$(readlink -f "$destination")
    
    # Protection from operating in critical directories
    case "$destination" in
        /|/boot|/home|/root|/etc|/var|/var/log|/usr|/bin|/sbin|/lib|/lib64|/dev|/proc|/sys|/tmp|/opt|/srv|/media|/mnt)
            echo "Error: Refusing to modify ACLs in critical directory '$destination'" >&2
            return 1
            ;;
    esac
    
    # Check if source exists and is readable
    if [[ ! -r "$source" ]]; then
        echo "Error: Cannot read source '$source'" >&2
        return 1
    fi
    
    # Check if destination exists
    if [[ ! -d "$destination" ]]; then
        echo "Error: Destination '$destination' does not exist or is not a directory" >&2
        return 1
    fi
    
    echo "Copying ACLs from '$source' to '$destination'..."
    
    if getfacl -p "$source" | setfacl -R --set-file=- "$destination"; then
        echo "ACLs copied successfully"
        chmod -R -v 775 "$destination"
    else
        echo "Error copying ACLs" >&2
        return 1
    fi
}
#@end_function

#@Name: catalog_dir
#@Description: Create a catalog of a directory's contents
#@Arguments: [directory] [output_file]
#@Usage: catalog_dir [directory] [output_file]
#@define help information
FUNCTION_HELP[catalog_dir]=$(cat << 'EOF'
NAME
    catalog_dir - Create a catalog of a directory's contents

DESCRIPTION
    This function creates a catalog of the contents of a directory, including a summary of file counts and sizes,
    a detailed listing of files, and a breakdown of file types.

USAGE
    catalog_dir [DIRECTORY] [OUTPUT_FILE]

OPTIONS
    -h, --help
        Show this help message and exit.

EXAMPLES

EOF
)
catalog_dir() {
  local dir="${1:-.}"
  local output="${2:-directory_catalog.txt}"

  {
    echo "Catalog of $dir created on $(date)"
    echo "----------------------------------------"
    
    # File count and total size
    echo "Summary:"
    find "$dir" -type f | wc -l | xargs echo "Total files:"
    du -sh "$dir" | awk '{print "Total size: " $1}'
    echo ""
    
    # Detailed listing with permissions, size, and date
    echo "Detailed listing:"
    /usr/bin/ls -lah "$dir"
    echo ""
    
    # File type breakdown
    echo "File types:"
    find "$dir" -type f | grep -v "^\." | sort | rev | cut -d. -f1 | rev | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr
  } >> "$output"

  echo "Catalog saved to $output"
}
#@end_function

#@Name: type
#@Description: Run type command and format output with bat
#@Arguments: function/alias/command
#@Usage: type nvim
#@define help information
FUNCTION_HELP[type]=$(cat << 'EOF'
NAME
    type - Show the type of a command
DESCRIPTION
    This function uses the `type` command to display the type of a command (alias, function, built-in, or executable).
USAGE
    type [COMMAND]
OPTIONS
    -h, --help
        Show this help message and exit.
EXAMPLES
    type ls
        Shows the type of the `ls` command.
EOF
)

function type() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -n "${FUNCTION_HELP[type]}" ]]; then
            echo "${FUNCTION_HELP[type]}"
        else
            echo "Help not available for function: type" >&2
            return 2
        fi
        return 0
    fi
    command type "$@" | bat -l sh
}

#################################################################################
#                               Installer Added                                 #
#################################################################################

# FNM
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi

# opencode
export PATH=/home/sigmachad/.opencode/bin:$PATH
