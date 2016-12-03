#!/bin/sh
backup=~/.dotfiles_backup/$(date +%m%d%H%M%Y%S
__dirname=$(dirname %0)
mkdir -p $backup
for file in $(ls -a | grep '^\.\w')
do
  mv ~/$file $backup 2>/dev/null
  echo " $__dirname/$file"
  ln -s $__dirname/$file ~
  rm -rf ~/.git
done
