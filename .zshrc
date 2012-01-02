[[ -s "/Users/stefan/.rvm/scripts/rvm" ]] && source "/Users/stefan/.rvm/scripts/rvm"  # This loads RVM into a shell session.

function git-ps1 {
  git-ref-and-time 2>/dev/null
}

function  build-prompt() {
  PROMPT="$(~/.rvm/bin/rvm-prompt u) [\$(git-ps1)]"
}
