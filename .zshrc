[[ -s "/Users/stefan/.rvm/scripts/rvm" ]] && source "/Users/stefan/.rvm/scripts/rvm"  # This loads RVM into a shell session.
[[ -s $HOME/.ey_config ]]               && source $HOME/.ey_config
[[ -s $HOME/.amazon_keys ]]             && source $HOME/.amazon_keys


export PATH=/Users/stefan/.rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/bin
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

# Allow for functions in the prompt.
setopt PROMPT_SUBST
build-prompt
