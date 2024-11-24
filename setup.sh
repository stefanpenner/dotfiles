#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

# Function to handle errors
trap 'echo "An error occurred. Exiting."; exit 1' ERR

# Ensure necessary tools are installed
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Please install it and try again."
    exit 1
fi

# Install Homebrew
echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo >> /Users/stef/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/stef/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Homebrew installation completed."

# Install useful tools with Homebrew
echo "Installing tools with Homebrew..."
brew install fish thefuck htop tree neovim nmap ripgrep jq
echo "Tools installed successfully: fish, thefuck, htop, tree, neovim, nmap, ripgrep, jq."

# Install Volta
echo "Installing Volta (JavaScript tool manager)..."
curl https://get.volta.sh | bash
echo "Volta installed successfully."

# Provide a summary
echo "All installations completed successfully!"
