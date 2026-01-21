#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        01-env.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines environment variables.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

#################################################################################
#####                                ENV                                    #####
#################################################################################
## nvim as default editor
if command -v nvim > /dev/null 2>&1; then
	export EDITOR="nvim"
else
	export EDITOR="nano"
fi

#################################################################################
#####                            BATCAT/BAT                                 #####
#################################################################################
# Symlink batcat to bat since some distros use batcat instead of bat
if ! command -v "bat" > /dev/null 2>&1; then
	if command -v "batcat" > /dev/null 2>&1; then
		ln -s /usr/bin/batcat /usr/bin/bat
	fi
fi

# Figure out if bat or batcat is installed, if not fall back on cat
function get_bat_command()
{
	local commands=("batcat" "bat")
	for cmd in "${commands[@]}"; do
		if command -v "$cmd" > /dev/null 2>&1; then
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
	bat_command=$(get_bat_command)
	export MANPAGER=
else
	export MANPAGER="less"
fi

if [ "$HOSTNAME" == "ix-truenas" ]; then
	export CDPATH=$HOME:/mnt/mach2/Pr0n:/mnt/toshiba/Pr0n.Datasets:/mnt/toshiba2/Pr0n.Datasets
elif [ "$HOSTNAME" == "ix-truenas" ]; then
	export CDPATH=$HOME:/mnt/zpool/Pron:/mnt/z2pool/Pr0n.Datasets
fi

