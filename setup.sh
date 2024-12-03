#!/bin/bash

set -euo pipefail

trap 'echo "An error occurred. Exiting."; exit 1' ERR

# Define color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
  echo -e "${BLUE}$1${NC}"
}

log_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

log_error() {
  echo -e "${RED}❌ $1${NC}"
  if [ "$2" = "exit" ]; then
    exit 1
  fi
}

download_and_extract() {
  local url=$1
  local zip_path=$2
  local extract_path=$3

  curl -fLo "$zip_path" "$url" || log_error "Failed to download from $url" "exit"
  unzip -o "$zip_path" -d "$extract_path" || log_error "Failed to extract $zip_path" "exit"
  rm "$zip_path" || log_error "Failed to remove $zip_path" "exit"
}

install_if_missing() {
  local cmd=$1
  local name=${2:-$1}
  local install_cmd=$3

  if ! command -v "$cmd" &>/dev/null; then
    log_info "📦 Installing $name..."
    eval "$install_cmd"
    log_success "$name installation completed"
  else
    log_success "$name is already installed"
  fi
}

clone_if_missing() {
  local dir=$1
  local name=$2
  local clone_cmd=$3

  if [ ! -d "$dir" ]; then
    log_info "📦 Installing $name..."
    eval "$clone_cmd"
    log_success "$name installation completed"
  else
    log_success "$name is already installed"
  fi
}

# Check for curl
if ! command -v curl &>/dev/null; then
  log_error "curl is not installed. Please install it and try again."
  exit 1
fi

# Install Homebrew
install_if_missing "brew" "Homebrew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

# Setup Homebrew environment
if [ ! -f "/Users/stef/.zprofile" ] || ! grep -q "brew shellenv" "/Users/stef/.zprofile"; then
  echo >>/Users/stef/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/stef/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install Homebrew packages
BREW_PACKAGES="fish thefuck htop tree nvim nmap rg jq bat lazygit lsd fzf aerospace fdr gum gh"
for package in $BREW_PACKAGES; do
  install_if_missing "$package" "$package" "brew install $package"
done

# Install Volta
install_if_missing "volta" "Volta" 'curl https://get.volta.sh | bash'

# Cargo
install_if_missing "cargo" "Cargo" 'curl https://sh.rustup.rs -sSf | sh'

# Install Oh My Zsh
clone_if_missing "$HOME/.oh-my-zsh" "Oh My Zsh" 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

# Install Powerlevel10k
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
clone_if_missing "$P10K_DIR" "Powerlevel10k" 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"'

# install zsh_codex
CODEX_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh_codex"
clone_if_missing "$CODEX_DIR" "zsh codex" '"git clone --depth=1https://github.com/tom-doerr/zsh_codex.git" "$CODEX_DIR"'

# Install Nerd Fonts
FONT_DIR="$HOME/Library/Fonts"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
FONT_ZIP="/tmp/FiraCode.zip"

if [ ! -d "$FONT_DIR" ]; then
  mkdir -p "$FONT_DIR" || log_error "Failed to create font directory" "exit"
  log_success "Font directory created"
fi

if ! ls "$FONT_DIR"/FiraCode*.ttf >/dev/null 2>&1; then
  log_info "🔤 Installing Fira Code Nerd Font..."
  download_and_extract "$FONT_URL" "$FONT_ZIP" "$FONT_DIR"
  log_success "Fira Code Nerd Font installed successfully"
else
  log_success "Fira Code Nerd Font is already installed"
fi

touch ~/.env

log_success "🎉 All installations completed successfully!"
