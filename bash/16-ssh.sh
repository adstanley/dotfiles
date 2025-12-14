#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        13-ssh.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines ssh aliases and functions.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

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