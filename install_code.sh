# Update system packages and install dependencies
sudo apt install wget gpg &&
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

# Add the official VS Code repository to your sources
echo "Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/vscode.sources

# Update package index and install VS Code
sudo apt update && sudo apt install code
