export EDITOR=nvim

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

function ssid() {
 /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s
}

function btc(){
  nc bitcoincharts.com 27007
}

function chrome() {
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --enable-extension-timeline-api &
}

function og {
  scp -r $1 og:~/htdocs/$2
  echo "http://static.iamstef.net/$2$1" | pbcopy
}

function pwdc {
  pwd | pbcopy
}

function git-ps1 {
  git-ref-and-time 2>/dev/null
}

function build_ps1() {
  PS1="[\h \W:\[\$(git-ps1)] \$ "
}

build_ps1

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
. "$HOME/.cargo/env"

. "$HOME/.local/bin/env"
