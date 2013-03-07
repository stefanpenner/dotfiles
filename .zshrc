# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="blinks"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git ruby autojump brews bundler gem  osx vim dircycle per-directory-history)

source $ZSH/oh-my-zsh.sh

source ~/.private
export EDITOR=vim
export PATH="/usr/local/git/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:$PATH"

function bct(){
  bundle list --paths | xargs /usr/local/bin/ctags -R *
}

function gitPromptOff(){
function git_prompt_info(){}
}

function def() {
  ack "def $argv"
}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
rvm reload

alias rd="rvm use default"
alias rdf="rvm use default && foreman start"
alias ls='gls --color=auto'
alias gg='git grep'
alias rvmd='rvm use default'

eval $( gdircolors -b $HOME/.LS_COLORS)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

function http(){
  ruby -run -e httpd -- --port 9999 .
}

alias git="hub"

function asdf() {
  if [ ! -p asdf ]; then
    mkfifo asdf;
  fi

  while true; do
    zsh -c "$(cat asdf)"
  done
}
