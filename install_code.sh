# Update system packages and install dependencies
sudo apt update
sudo apt install wget gpg apt-transport-https

# Download and import the Microsoft GPG signing key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg > /dev/null

# Add the official VS Code repository to your sources
echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://microsoft.com stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

# Update package index and install VS Code
sudo apt update
sudo apt install code
