#!/bin/bash

set -e

echo "Downloading and installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

echo "Sourcing nvm script..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "Installing Node.js version 22..."
nvm install 22

# Verify the installed Node.js version
echo "Verifying Node.js installation..."
NODE_VERSION=$(node -v)
NVM_CURRENT=$(nvm current)
NPM_VERSION=$(npm -v)

echo "Node.js version: $NODE_VERSION"
echo "nvm current: $NVM_CURRENT"
echo "npm version: $NPM_VERSION"

# Enable the Bluetooth service
sudo systemctl enable bluetooth
# Start the Bluetooth service
sudo systemctl start bluetooth

sudo systemctl enable ly.service





#Set shell to zsh
chsh -s /usr/bin/zsh
