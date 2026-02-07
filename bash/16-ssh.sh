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
# if ssh folder is missing make it
if [ ! -d "$HOME/.ssh" ]; then
	mkdir -p "$HOME/.ssh"
	chmod 700 "$HOME/.ssh"
fi


# if [ -z "$SSH_AUTH_SOCK" ]; then
# 	# Start the ssh-agent in the background
# 	eval "$(ssh-agent -s)" >/dev/null 2>&1

# 	# Add all keys in ~/.ssh except for known_hosts and config
# 	readarray -t ssh_keys < <(find ~/.ssh -type f -not -iname "*.pub" -not -name "known_hosts" -not -name "config" 2>/dev/null)

# 	for key in "${ssh_keys[@]}"; do
# 		ssh-add "$key" 2>/dev/null
# 	done
# fi

# SSH Agent Management
# Check for existing agent or start a new one
if [ -z "$SSH_AUTH_SOCK" ]; then
	# Look for existing agent info
	SSH_ENV="$HOME/.ssh/agent-env"
	
	if [ -f "$SSH_ENV" ]; then
		source "$SSH_ENV" >/dev/null
		
		# Verify the agent is still running
		if ! ps -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
			# Agent died, start a new one
			eval "$(ssh-agent -s)" >"$SSH_ENV"
			source "$SSH_ENV" >/dev/null
		fi
	else
		# No existing agent, start new one
		eval "$(ssh-agent -s)" >"$SSH_ENV"
		source "$SSH_ENV" >/dev/null
	fi
fi

# Add SSH keys if agent is running and keys aren't already loaded
if [ -n "$SSH_AUTH_SOCK" ]; then
	# Get list of currently loaded keys
	loaded_keys=$(ssh-add -l 2>/dev/null)
	
	# Only add keys if none are loaded (exit code 1 means no keys)
	if [ $? -eq 1 ]; then
		# Find private keys (common patterns)
		readarray -t ssh_keys < <(find ~/.ssh -type f \
			\( -name "id_rsa" -o -name "id_ed25519" -o -name "id_ecdsa" -o -name "id_dsa" \) \
			2>/dev/null)
		
		# Add each key silently
		for key in "${ssh_keys[@]}"; do
			ssh-add "$key" >/dev/null 2>&1
		done
	fi
fi