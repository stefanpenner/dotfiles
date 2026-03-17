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
  echo -e "${RED}$1${NC}"
  if [ "${2:-}" = "exit" ]; then
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
    log_info "Installing $name..."
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
    log_info "Installing $name..."
    eval "$clone_cmd"
    log_success "$name installation completed"
  else
    log_success "$name is already installed"
  fi
}

# --- Platform detection ---
OS="$(uname -s)"

# Check for curl
if ! command -v curl &>/dev/null; then
  log_error "curl is not installed. Please install it and try again." "exit"
fi

# --- Homebrew (install if missing on macOS) ---
if [[ "$OS" == "Darwin" ]] && ! command -v brew &>/dev/null; then
  install_if_missing "brew" "Homebrew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# --- brew shellenv in .zprofile ---
if command -v brew &>/dev/null; then
  if [ ! -f "$HOME/.zprofile" ] || ! grep -q "brew shellenv" "$HOME/.zprofile"; then
    echo >>"$HOME/.zprofile"
    echo "eval \"\$($(command -v brew) shellenv)\"" >>"$HOME/.zprofile"
  fi
fi

# --- Install packages ---
PACKAGES="fish thefuck htop tree nvim nmap rg jq bat bat-extras lazygit lsd fzf fd gum gh watch wget ast-grep viu chafa jstkdng/programs/ueberzugpp luarocks direnv zsh-autosuggestions zsh-fast-syntax-highlighting zsh-history-substring-search"

if command -v brew &>/dev/null; then
  for package in $PACKAGES; do
    install_if_missing "$package" "$package" "brew install $package"
  done
else
  log_info "No brew found. Install these packages with your package manager:"
  log_info "  $PACKAGES"
fi

# Install Volta
install_if_missing "volta" "Volta" 'curl https://get.volta.sh | bash'

# Cargo
install_if_missing "cargo" "Cargo" 'curl https://sh.rustup.rs -sSf | sh'

# Install Powerlevel10k
P10K_DIR="$HOME/.config/zsh/plugins/powerlevel10k"
mkdir -p "$P10K_DIR"
clone_if_missing "$P10K_DIR" "Powerlevel10k" 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"'

# --- Install Nerd Fonts (platform-aware path) ---
if [[ "$OS" == "Darwin" ]]; then
  FONT_DIR="$HOME/Library/Fonts"
else
  FONT_DIR="$HOME/.local/share/fonts"
fi
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
FONT_ZIP="/tmp/FiraCode.zip"

mkdir -p "$FONT_DIR"
if ! ls "$FONT_DIR"/FiraCode*.ttf >/dev/null 2>&1; then
  log_info "Installing Fira Code Nerd Font..."
  download_and_extract "$FONT_URL" "$FONT_ZIP" "$FONT_DIR"
  # Rebuild font cache on Linux
  [[ "$OS" != "Darwin" ]] && command -v fc-cache &>/dev/null && fc-cache -f "$FONT_DIR"
  log_success "Fira Code Nerd Font installed successfully"
else
  log_success "Fira Code Nerd Font is already installed"
fi

touch ~/.env

log_success "All installations completed successfully!"
