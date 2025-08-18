#!/usr/bin/env bash

# Get key
wget https://dl-ssl.google.com/linux/linux_signing_key.pub -O /tmp/google.pub

# Add key
gpg --no-default-keyring --keyring /etc/apt/keyrings/google-chrome.gpg --import /tmp/google.pub

# Add repository
echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] \
    http://dl.google.com/linux/chrome/deb/ stable main' \
    | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Remove temp file
rm /tmp/google.pub

# Update package list
sudo apt-get update

# Install Google Chrome
sudo apt-get install -y google-chrome-stable