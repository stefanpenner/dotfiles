#!/bin/sh

basename="$HOME/src/stefanpenner/dotfiles"
backup=~/.dotfiles_backup/$(date +%m%d%H%M%Y%S)

for file in $(find $basename -maxdepth 1 -iname '.*' -not -path '*/.git')
do
  filename=$(basename $file)
  mv "$HOME/$filename" "$backup" 2>/dev/null
  rm -rf "$HOME/$filename"
  echo " $file => ~/$filename"
  ln -s "$file" ~
done
