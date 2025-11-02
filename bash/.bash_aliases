#################################################################################
#####                            Aliases                                    #####
#################################################################################

# Some aliases are functions
# nvim is an alias to nvim.appimage if it exists

# Declare associative array for function help
declare -A FUNCTION_HELP

# Filesystem Shortcuts
#@Name: cd_drive
#@Description: Change directory to a specified drive
#@Arguments: [directory]
#@Usage: cd_drive [directory]
#@define help information
FUNCTION_HELP[cd_drive]=$(
	cat <<'EOF'
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
		cd "$dir" || {
			printf "Failed to change to %s\n" "$dir"
			return 1
		}
	else
		printf "Directory %s does not exist\n" "$dir"
		return 1
	fi
}
#@end_function

alias resetcursor='printf \e[5 q'

# Directory shortcuts
alias cd_sab='cd /mnt/spool/SABnzbd/Completed'
alias cd_torrent='cd /mnt/spool/torrent'
alias cd_pron='cd /mnt/z2pool/Pr0n'

# Drive shortcuts
alias cd_toshiba='cd /mnt/toshiba'
alias cd_toshiba2='cd /mnt/toshiba2'
alias cd_toshiba3='cd /mnt/toshiba3'
alias cd_toshiba4='cd /mnt/toshiba4'
alias cd_spool='cd /mnt/spool'
alias cd_spool-temp='cd /mnt/spool-temp'
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