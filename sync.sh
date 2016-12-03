#!/bin/sh
backup=~/.dotfiles_backup/$(date +%m%d%H%M%Y%S)
script="$0"
basename="$(dirname $script)"
mkdir -p $backup
for file in $(ls -a $basename | grep '^\.\w')
do
  mv ~/$file $backup 2>/dev/null
  echo " $basename/$file"
  ln -s $basename/$file ~
  rm -rf ~/.git
done
