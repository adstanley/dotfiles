set_xdg_dirs() {
    # Define defaults in an associative array (Bash 4+ required; most modern systems have it)
    declare -A xdg_defaults
    xdg_defaults[CONFIG_HOME]="${HOME}/.config"
    xdg_defaults[DATA_HOME]="${HOME}/.local/share"
    xdg_defaults[CACHE_HOME]="${HOME}/.cache"
    xdg_defaults[STATE_HOME]="${HOME}/.local/state"

    for var in CONFIG_HOME DATA_HOME CACHE_HOME STATE_HOME; do
        env_var="XDG_${var}"
        if [ -z "${!env_var}" ]; then
            export "${env_var}"="${xdg_defaults[$var]}"
            # Optionally create the dir if it doesn't exist
            mkdir -p "${!env_var}"
        fi
    done
}

set_xdg_dirs
unset set_xdg_dirs  # Clean up the function after use (optional, to avoid polluting namespace)

# Set XDG Base Directories with defaults if unset/empty
: "${XDG_CONFIG_HOME:=${HOME}/.config}"
: "${XDG_DATA_HOME:=${HOME}/.local/share}"
: "${XDG_CACHE_HOME:=${HOME}/.cache}"
: "${XDG_STATE_HOME:=${HOME}/.local/state}"

export XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME XDG_STATE_HOME