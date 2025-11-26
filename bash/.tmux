    reattach_client() {
      if [[ $# -lt 1 ]]; then
        echo -e "Usage:\nreattach_client <tmux_session_name>"
        return
      fi
      tmux list-client | grep "$1" | awk '{split($1, s, ":"); print s[1]}' | xargs tmux detach-client -t | true
      tmux attach -t "$1"
    }