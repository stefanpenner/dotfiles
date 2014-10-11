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
plugins=(git ruby brew gem gitfast git-extras osx vim)

source $ZSH/oh-my-zsh.sh

source ~/.private
export EDITOR=vim
export PATH=":/usr/local/share/npm/bin/:/Users/stefan/src/depot_tools:/usr/local/git/bin:/usr/local/sbin:/bin:/usr/sbin:/sbin:/usr/X11/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/MacOS/bin:$PATH"

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

alias rd='rvm use default'
alias rdf='rvm use default && foreman start'
alias gg='git grep'
alias rvmd='rvm use default'
alias be='bundle exec'

# https://www.youtube.com/watch?v=SMWi7CLoZ2Q
function nom() {
  if [ -z "$1" ]; then
   rm -rf node_modules && npm cache clear && npm i
   return
  fi

  `npm $@`
}


alias pyg="pygmentize"
function http(){
  ruby -run -e httpd -- --port 9999 .
}

function asdf() {
  if [ ! -p asdf ]; then
    mkfifo asdf;
  fi

  while true; do
    zsh -c "$(cat asdf)"
  done
}

function qunit(){
  phantomjs tests/qunit/run-qunit.js 'http://localhost:9999/tests/test.html'
}

export YAPP_PROJECTS_DIR='/Users/stefan/src/yapp/projects/'
export DYLD_FALLBACK_LIBRARY_PATH=/Applications/Postgres.app/Contents/MacOS/lib:/usr/local/lib:$DYLD_LIBRARY_PATH

echo "Victorious warriors win first and then go to war, while defeated warriors go to war first and then seek to win."

function nus {
  nave.sh use stable;
}
source /Users/stefan/.iterm2_shell_integration.zsh

# OPAM configuration
. /Users/stefan/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
