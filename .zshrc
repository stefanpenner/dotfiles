[[ -s "/Users/stefan/.rvm/scripts/rvm" ]] && source "/Users/stefan/.rvm/scripts/rvm"  # This loads RVM into a shell session.
[[ -s $HOME/.ey_config ]]               && source $HOME/.ey_config
[[ -s $HOME/.amazon_keys ]]             && source $HOME/.amazon_keys

export PERVASIVE_DB="jdbc:pervasive://hdswpg.dyndns.org:1583/svrdata"
export SRVDATA="jdbc:pervasive://hdswpg.dyndns.org:1583/svrdata"
export HDSPRICEKIOSK="jdbc:pervasive://hdswpg.dyndns.org:1583/hdsPriceKiosk"

export PATH=/Users/stefan/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin
export EDITOR=vim

alias ls="ls -G"

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

autoload -U colors
colors

function ggr() {
  if [[ "$#" == "0" ]]; then
    echo 'Usage:'
    echo '  gg_replace term replacement file_mask'
    echo
    echo 'Example:'
    echo '  gg_replace cappuchino cappuccino *.html'
    echo
  else
    find=$1; shift
    replace=$1; shift

    while [[ "$#" -gt "0" ]]; do
      for file in `git grep -l $find **/$1`; do
        sed -i '' "s/$find/$replace/g" $file
      done
      shift
    done
  fi
}
function gg_dasherize() {
  gg_replace $1 `echo $1 | sed -e 's/_/-/g'` $2
}

function server(){
  ruby -rwebrick -e's = WEBrick::HTTPServer.new(:Port => 9999, :DocumentRoot => Dir.pwd);  Signal.trap("INT"){s.stop}; system("which open && open http://127.0.0.1:9999");s.start'
}

function og {
  scp -r $1 og:~/htdocs/$2
  echo "http://static.iamstef.net/$2$1" | pbcopy
}

function pwdc {
  pwd | pbcopy
}

function git-ps1 {
  echo $(git-ref-and-time 2>/dev/null)
}

function build-prompt {
  PROMPT="$turbo_tag\$(~/.rvm/bin/rvm-prompt u) [%n@%m %c:\$(git-ps1)] \$ "
}

function define_vim_wrappers()
{
  eval "function vim () { ( rvm use system && /usr/local/Cellar/macvim/HEAD/MacVim.app/Contents/MacOS/Vim  \$@) }"
  eval "function mvim () { ( rvm use system && /usr/local/bin/mvim \$@) }"
}


define_vim_wrappers

set autocd
# Allow for functions in the prompt.
setopt PROMPT_SUBST
build-prompt


# fixme - the load process here seems a bit bizarre

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

WORDCHARS=''

zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# use /etc/hosts and known_hosts for hostname completion
[ -r /etc/ssh/ssh_known_hosts ] && _global_ssh_hosts=(${${${${(f)"$(</etc/ssh/ssh_known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_global_ssh_hosts[@]"
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  "$HOST"
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.oh-my-zsh/cache/

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle '*' single-ignored show

if [ "x$COMPLETION_WAITING_DOTS" = "xtrue" ]; then
  expand-or-complete-with-dots() {
    echo -n "\e[31m......\e[0m"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  bindkey "^I" expand-or-complete-with-dots
fi

autoload -U compinit
compinit -i


