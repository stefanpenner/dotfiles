#!/bin/sh
backup=~/.dotfiles_backup/$(date +%m%d%H%M%Y%S)
mkdir -p $backup
for file in $(ls -a | grep '^\.\w')
do
  mv ~/$file $backup 2>/dev/null
  echo " $file"
  ln -s $(pwd)/$file ~
  rm -rf ~/.git
done
