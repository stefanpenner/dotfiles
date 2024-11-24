#!/bin/bash

set -euo pipefail

trap 'echo "An error occurred. Exiting."; exit 1' ERR

if ! command -v curl &>/dev/null; then
  echo "curl is not installed. Please install it and try again."
  exit 1
fi

echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo >>/Users/stef/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/stef/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Homebrew installation completed."

echo "Installing tools with Homebrew..."
brew install fish thefuck htop tree neovim nmap ripgrep jq bat lazygit
echo "Tools installed successfully: fish, thefuck, htop, tree, neovim, nmap, ripgrep, jq, lazygit."

echo "Installing Volta (JavaScript tool manager)..."
curl https://get.volta.sh | bash
echo "Volta installed successfully."

echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "oh-my-zsh installed successfully."

sh ./scripts/fira-code.sh
touch ~/.env

echo "All installations completed successfully!"
