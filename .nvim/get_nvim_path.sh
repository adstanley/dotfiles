#!/usr/bin/env bash

# Define potential Neovim paths to check (add your custom paths)
NVIM_PATHS=(
    "/usr/bin/nvim"
    "/usr/local/bin/nvim"
    "$HOME/.local/bin/nvim"
    "$HOME/bin/nvim"
    # Add any other paths where you might have Neovim installed
)

# Function to extract Neovim version number
function get_nvim_version() {
    local nvim_path="$1"
    local version
    
    # Get the version string and extract just the numeric part
    version=$("$nvim_path" -v | grep -o "NVIM v[0-9]\+\.[0-9]\+\.[0-9]\+" | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+")
    
    # Return the version
    echo "$version"
}

# Function to find the latest Neovim installation
function find_latest_nvim() {
    local paths=("$@")
    local latest_version="0.0.0"
    local latest_path=""
    
    for path in "${paths[@]}"; do
        if command -v "$path" >/dev/null 2>&1; then
            local version
            version=$(get_nvim_version "$path")
            
            # Compare versions using sort and take the higher one
            if [[ "$(printf '%s\n' "$latest_version" "$version" | sort -V | tail -n1)" == "$version" ]]; then
                latest_version="$version"
                latest_path="$path"
            fi
        fi
    done
    
    # If we found a valid path, return it
    if [[ -n "$latest_path" ]]; then
        echo "$latest_path"
    else
        # Return default 'nvim' and let PATH resolution handle it
        echo "nvim"
    fi
}

# Set the latest Neovim as the EDITOR
LATEST_NVIM=$(find_latest_nvim "${NVIM_PATHS[@]}")
export EDITOR="$LATEST_NVIM"

# Function to run Neovim with the latest version
nvim() {
    "$LATEST_NVIM" "$@"
}

# Optional: Show which version is being used (comment this out if not wanted)
echo "Using Neovim $(get_nvim_version "$LATEST_NVIM") from $LATEST_NVIM"