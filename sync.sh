#!/bin/sh
set -euo pipefail

trap 'echo "An error occurred. Exiting."; exit 1' ERR

basename="$HOME/src/stefanpenner/dotfiles"
backup="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

mkdir -p "$backup"

find "$basename" -maxdepth 1 -iname '.*' -not -path '*/.git' | while read -r file; do
  filename=$(basename "$file")

  if [ -e "$HOME/$filename" ]; then
    mv "$HOME/$filename" "$backup" || true
  fi

  rm -rf "$HOME/$filename"
  echo " $file => ~/$filename"
  ln -s "$file" "$HOME/$filename"
done
