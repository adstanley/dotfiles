#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        09-nvim.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines nvim alias and function.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

# Declare associative array for function help
declare -A FUNCTION_HELP

#################################################################################
#####                               NVIM                                    #####
#################################################################################

#@Name: nvim
#@Description: Launch best available Neovim installation
#@Usage: nvim [options] [files...]
FUNCTION_HELP[nvim]=$(
	cat <<'EOF'
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
nvim_old()
{
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
		# Priority order: local compile, Appimage, system package
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

nvim() {
    # Find nvim once and cache it
    [[ -z "$NVIM_PATH" ]] && NVIM_PATH=$(which nvim 2>/dev/null || command -v nvim)
    [[ -z "$NVIM_PATH" ]] && { echo "nvim not found" >&2; return 1; }

    # If you have a huge config, start minimal the first time over ssh
    if [[ -n "$SSH_CONNECTION" && ! -e "$HOME/.nvim-minimal" ]]; then
        echo "Starting minimal Neovim over SSH to avoid OOM..."
        "$NVIM_PATH" -u NORC "$@"
        touch "$HOME/.nvim-minimal"
        return
    fi

    exec "$NVIM_PATH" "$@"
}

nvim_reset()
{
	unset NVIM_PATH
	echo "Neovim path cache cleared"
}