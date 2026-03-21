#!/bin/sh
set -euo pipefail

DOTFILES_REPO="stefanpenner/dotfiles"
DOTFILES_DIR="$HOME/src/stefanpenner/dotfiles"

log() { printf '==> %s\n' "$1"; }

# --- Step 1: Install dotpack (hermetic tool bundle) ---
if ! command -v dotpack >/dev/null 2>&1; then
  log "Installing dotpack..."
  curl -fsSL "https://github.com/stefanpenner/dotpack/releases/latest/download/install.sh" | bash
  # shellcheck disable=SC1090
  . "$HOME/.profile"
else
  log "dotpack already installed ($(dotpack version))"
fi

# --- Step 2: Clone dotfiles ---
if [ ! -d "$DOTFILES_DIR" ]; then
  log "Cloning dotfiles..."
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  git clone "https://github.com/$DOTFILES_REPO.git" "$DOTFILES_DIR"
else
  log "dotfiles already cloned"
fi

# --- Step 3: Symlink config ---
log "Syncing dotfiles..."
"$DOTFILES_DIR/sync.sh"

log "Done. Open a new shell to pick up changes."
