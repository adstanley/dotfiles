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

#################################################################################
#####                             LS/EXA                                    #####
#################################################################################

#@Name: get_ls_command
#@Description: Get preferred ls command (eza, exa, or ls)
#@Usage: get_ls_command
#@define help information
function get_ls_command()
{
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
export LS_COMMAND