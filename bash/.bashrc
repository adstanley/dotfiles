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
# Bashrc

# Declare associative array for function help
declare -A FUNCTION_HELP

## If not running interactively, don't do anything
# This prevents functions, aliases, and paths from being loaded 
# unnecessarily by non-interactive shells (like scripts or sftp sessions).
[[ $- != *i* ]] && return

#################################################################################
#                       Change to Modular Structure                             #
#################################################################################

# Example of sourcing OS specific configurations
# [[ $HOSTNAME == "truenas2" ]] && source truenas-specific.sh
# [[ $HOSTNAME == "ix-truenas" ]] && source truenas-specific.sh
# [[ $(uname) == "Linux" ]] && modular_files+=("linux-specific.sh")
# [[ $(uname) == "WSL" ]] && modular_files+=("wsl-specific.sh")

#################################################################################

# Debug
# BASH_DEBUG="true"
BASH_DEBUG="false"

# Path to your modular config directory
MODULAR_DIR="${HOME}/.github/dotfiles/bash"

# Force standard byte-order sorting for this loop
LC_COLLATE=C

# Start timer for performance measurement
# SECONDS=0

# Print a welcome message
printf "\e[0;92mWelcome to your modular Bash configuration!\e[0m\n"
# cat /run/motd.dynamic

# Print a newline for readability
printf "\n"

# Source each modular file
for full_path in "${MODULAR_DIR}"/*.sh; do
    # if the path is readable, source it, this is ai slop added probably delete
    # why wouldn't it be readable
    if [[ "$full_path" == *ssh* ]]; then
        printf "\e[0;91mDebug\e[0m  : skip SSH file:%s\n" "$full_path"
        continue
    fi

    if [[ -r "$full_path" ]]; then
        source "$full_path"
        # [[ "$BASH_DEBUG" == "true" ]] && printf "Sourced: %s\n" "$full_path"
        printf "Sourced: %s\n" "$full_path"
    else
        echo "Warning: Cannot read $full_path" >&2
    fi
done

# if [[ "$BASH_DEBUG" == "true" ]]; then
#     printf "Debug: Sourced modular files in %d seconds.\n" "$SECONDS"
# fi   

# printf "Bash modular configuration loaded in %d seconds.\n" "$SECONDS"

# Cleanup variables to avoid polluting the environment
unset full_path SECONDS BASH_DEBUG MODULAR_DIR

#################################################################################
#                               Installer Added                                 #
#################################################################################

# opencode
export PATH=/home/sigmachad/.opencode/bin:$PATH

# . "$HOME/.atuin/bin/env"

# [[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
# eval "$(atuin init bash)"
