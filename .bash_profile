[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
set -o vi 
export MANPATH=/usr/local/git/man:$MANPAT
export PATH=/Applications/MacVim.app/Contents/MacOS:/opt/local/bin:/opt/local/sbin:/usr/local/sbin:/usr/local/bin:/usr/local/share/npm/bin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH
export EDITOR=vim

#source `brew --prefix git`/etc/bash_completion.d/git-completion.bash

alias b="bundle exec"
alias eclimd='/Applications/Eclipse/eclimd'
alias pwdc="pwd | pbcopy"
alias g=git
alias gg='git grep'
alias a='ack'
alias aa='ack -a'
alias aai='ack -ai'

alias g='grep'
alias t='tail'
alias h='head'
alias L='less'

alias cl="clear;ls"
alias cls="clear;ls"
alias vg='valgrind --leak-check=full --show-possibly-lost=no --dsymutil=yes'

function ssid(){
 /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s
}
function btc(){
  nc bitcoincharts.com 27007
}
function chrome(){
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --enable-extension-timeline-api &

}
function setJTurbo(){
  export JAVA_OPTS="-d32 -Xmx2048m"
}

function unsetJTurbo(){
  unset JAVA_OPTS
}

#export JRUBY_OPTS=--1.9

function turbo(){
  if [[ $RUBY_HEAP_MIN_SLOTS != 1000000 ]]
  then
    export RUBY_HEAP_MIN_SLOTS=1000000
    export RUBY_HEAP_SLOTS_INCREMENT=1000000
    export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
    export RUBY_HEAP_FREE_MIN=500000
    export RUBY_GC_MALLOC_LIMIT=1000000000
    export turbo_tag="⚡"

  else
    unset RUBY_HEAP_MIN_SLOTS
    unset RUBY_HEAP_SLOTS_INCREMENT
    unset RUBY_HEAP_SLOTS_GROWTH_FACTOR
    unset RUBY_HEAP_FREE_MIN
    unset RUBY_GC_MALLOC_LIMIT
    unset turbo_tag

  fi
  build_ps1
}
function nzbload {
  for nzb in ~/Downloads/*.nzb
  do
    hellanzb.py enqueue "$nzb"
    rm -rf "$nzb"
  done
}

function og {
  scp -r $1 og:~/htdocs/$2
  echo "http://static.iamstef.net/$2$1" | pbcopy
}

function pwdc {
  pwd | pbcopy
}

function linux {
  qemu-system-x86_64 -m 512 -hda archlinux.qcow2 -redir tcp:2222::22 \
                            -nographic -daemonize
}

function powCycle {
  echo "*** Stopping the Pow server..."
  launchctl unload -F "$HOME/Library/LaunchAgents/cx.pow.powd.plist" || true
  echo "*** Starting the Pow server..."
  launchctl load -F "$HOME/Library/LaunchAgents/cx.pow.powd.plist"
}

function powOff {
  sudo launchctl unload /Library/LaunchDaemons/cx.pow.firewall.plist
  sudo ipfw flush
}

function powOn {
  sudo launchctl load /Library/LaunchDaemons/cx.pow.firewall.plist
}

function server(){
ruby -rwebrick -e's = WEBrick::HTTPServer.new(:Port => 9999, :DocumentRoot => Dir.pwd);  Signal.trap("INT"){s.stop}; system("which open && open http://127.0.0.1:9999");s.start'
}

# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

function git-ps1 {
  git-ref-and-time 2>/dev/null
}

function build_ps1 {
  PS1="$turbo_tag\$(~/.rvm/bin/rvm-prompt u) [\h \W:\[\$(git-ps1)] \$ "
}

turbo
build_ps1

[[ -s $HOME/.ey_config ]]               && source $HOME/.ey_config
[[ -s $HOME/.amazon_keys ]]             && source $HOME/.amazon_keys
[[ -s $HOME/.rvm/scripts/rvm ]]         && source /Users/stefan/.rvm/scripts/rvm
[[ -s $HOME/.rvm/scripts/rvm ]]         && source /Users/stefan/.rvm/scripts/rvm
[[ -r $rvm_path/scripts/completion ]]   && source $rvm_path/scripts/completion

