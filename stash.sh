#!/usr/bin/env bash

command_name=stash

if which $command_name > /dev/null 2>&1; then
    printf "%s is installed. Script will continue." "$command_name"
else
    printf "%s is not installed. Script will exit." "$command_name"
    exit 1
fi