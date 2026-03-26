#!/usr/bin/env bash
# ----------------------------------------------------------------------
# FILE:        13-ssh.sh
# AUTHOR:      Sigmachad
# DATE:        2025-11-20
# DESCRIPTION: Defines ssh aliases and functions.
# USAGE:       Sourced by ~/.bashrc. Do not execute directly.
# ----------------------------------------------------------------------

# --- FILE CONTENT STARTS HERE --- #

# ----------------------------------------------------------------------
# Helper: start a fresh ssh-agent and write its env to $SSH_ENV
# ----------------------------------------------------------------------
_start_agent() {
    local env_file="${SSH_ENV:-$HOME/.ssh/agent-env}"
    
    # Kill any existing agent first
    if [[ -n "$SSH_AGENT_PID" ]] && kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
        ssh-agent -k >/dev/null 2>&1
    fi
    
    # Start new agent and save environment
    ssh-agent -s | grep -v '^echo' > "$env_file"
    chmod 600 "$env_file"
    
    # Source the environment
    # shellcheck source=/dev/null
    source "$env_file" >/dev/null 2>&1
}

# ----------------------------------------------------------------------
# Ensure ~/.ssh exists and has correct permissions
# ----------------------------------------------------------------------
if [[ ! -d "$HOME/.ssh" ]]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

# ----------------------------------------------------------------------
# Set up SSH agent environment
# ----------------------------------------------------------------------
SSH_ENV="${SSH_ENV:-$HOME/.ssh/agent-env}"

# Check if agent is already running in this session
if [[ -z "$SSH_AUTH_SOCK" ]] || [[ ! -S "$SSH_AUTH_SOCK" ]]; then
    # Try to load existing agent environment
    if [[ -f "$SSH_ENV" ]]; then
        # shellcheck source=/dev/null
        source "$SSH_ENV" >/dev/null 2>&1
        
        # Verify the agent is actually running
        if [[ -z "$SSH_AGENT_PID" ]] || ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
            # Agent is dead, start a new one
            _start_agent
        elif [[ ! -S "$SSH_AUTH_SOCK" ]]; then
            # PID exists but socket is gone, start a new one
            _start_agent
        fi
    else
        # No env file exists, start a new agent
        _start_agent
    fi
fi

# ----------------------------------------------------------------------
# Add SSH keys if agent is running and no keys are loaded
# ----------------------------------------------------------------------
if [[ -n "$SSH_AUTH_SOCK" ]] && [[ -S "$SSH_AUTH_SOCK" ]]; then
    # Check if any keys are loaded (exit code 0 = keys present, 1 = no keys)
    if ! ssh-add -l >/dev/null 2>&1; then
        # Find all private key files
        shopt -s nullglob
        keys=()
        
        for key_file in "$HOME/.ssh"/id_{rsa,ed25519,ecdsa,dsa}; do
            # Check it's a file, readable, and not a public key
            if [[ -f "$key_file" && -r "$key_file" && "$key_file" != *.pub ]]; then
                keys+=("$key_file")
            fi
        done
        
        # Add each key
        if [[ ${#keys[@]} -gt 0 ]]; then
            for key in "${keys[@]}"; do
                ssh-add "$key" 2>/dev/null
            done
        fi
        
        shopt -u nullglob
    fi
fi

# Clean up helper function
unset -f _start_agent

# ----------------------------------------------------------------------
# Optional SSH aliases and functions
# ----------------------------------------------------------------------

# Example: Quick SSH with specific key
# alias sshkey='ssh -i ~/.ssh/id_ed25519'

# Example: SSH with port forwarding
# sshforward() {
#     local port="${1:-8080}"
#     local host="${2:-localhost}"
#     ssh -L "${port}:localhost:${port}" "$host"
# }