#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

if [ -d "$HOME/.ssh" ]; then
  echo "~/.ssh already exists. Exiting to avoid overwriting existing SSH configuration."
  exit 1
fi