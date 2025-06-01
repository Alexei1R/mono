
#!/bin/bash

set -e

# Install nvm (Node Version Manager)
echo "Downloading and installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Source nvm script (in lieu of restarting the shell)
echo "Sourcing nvm script..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node.js version 22
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

# Check if the expected versions are installed
if [[ "$NODE_VERSION" == "v22.15.0" && "$NVM_CURRENT" == "v22.15.0" && "$NPM_VERSION" == "10.9.2" ]]; then
  echo "Node.js, nvm, and npm installed successfully!"
else
  echo "Warning: Installed versions may not match the expected versions."
fi

# Enable the Bluetooth service
sudo systemctl enable bluetooth
# Start the Bluetooth service
sudo systemctl start bluetooth

sudo systemctl enable ly.service





#Set shell to zsh
chsh -s /usr/bin/zsh
