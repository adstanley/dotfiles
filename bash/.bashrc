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
DEBUG="true"

# Path to your modular config directory
MODULAR_DIR="${HOME}/.github/dotfiles/bash"

# Force standard byte-order sorting for this loop
LC_COLLATE=C

# Source each modular file
for full_path in "${MODULAR_DIR}"/*.sh; do
    if [[ -r "$full_path" ]]; then
        source "$full_path"
        [[ "$DEBUG" == "true" ]] && printf "sourced %s\n" "$full_path"
    else
        echo "Warning: Cannot read $full_path" >&2
    fi
done

# Unset full_path
unset full_path

#################################################################################
#                               Installer Added                                 #
#################################################################################

# opencode
export PATH=/home/sigmachad/.opencode/bin:$PATH
