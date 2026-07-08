#!/usr/bin/env bash

# Setup the Google signer and repo
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/google.asc >/dev/null

# Add the Google Chrome repository to your sources list
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' 

# Install
sudo apt-get update
sudo apt-get install google-chrome-stable