#!/bin/bash
set -euo pipefail

dotfiles="$(cd "$(dirname "$0")" && pwd)"
backup="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

mkdir -p "$backup"

find "$dotfiles" -maxdepth 1 -iname '.*' -not -name '.git' | while read -r file; do
  filename=$(basename "$file")

  if [ -e "$HOME/$filename" ]; then
    mv "$HOME/$filename" "$backup" || true
  fi

  rm -rf "${HOME:?}/$filename"
  echo " $file => ~/$filename"
  ln -s "$file" "$HOME/$filename"
done
