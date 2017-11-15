#!/bin/sh

basename="$HOME/src/stefanpenner/dotfiles"

for file in $(find $basename -maxdepth 1 -iname '.*' -not -path '*/.git')
do
  mv ~/$file $backup 2>/dev/null
  echo " $basename/$file"
  ln -s $basename/$file ~
done
