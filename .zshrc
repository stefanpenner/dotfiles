export XDG_CONFIG_HOME=$HOME/.config

# Ghostty
if [[ "$TERM_PROGRAM" == "Ghostty" ]] || [[ -n "$GHOSTTY_VERSION" ]]; then
  export COLORTERM=truecolor
  export TERM=xterm-256color
fi

# p10k instant prompt (must stay near top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Shared config
source "$XDG_CONFIG_HOME/zsh/rc.zsh"

# --- Machine-specific ---
export EDITOR=nvim
export FLYCTL_INSTALL="$HOME/.fly"
export BUN_INSTALL="$HOME/.bun"

# Secretive SSH agent (only if socket exists)
local _secretive_sock="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
[[ -S "$_secretive_sock" ]] && export SSH_AUTH_SOCK="$_secretive_sock"

path_prepend \
  "$HOME/bin" \
  "$HOME/.fly/bin" \
  "$HOME/.bun/bin" \
  "$HOME/.local/bin" \
  "$HOME/sdk/go/bin" \
  "$HOME/go/bin"

# Aliases
alias dsh='doppler run --project aiur --config=workstation -- $SHELL'
alias denv='doppler secrets download --no-file --format env'

owu() {
  DATA_DIR=~/.open-webui uvx --python 3.11 open-webui@latest serve
}

# Env loading
if [[ -f ~/.env ]]; then
  set -a
  source ~/.env
  set +a
fi
[[ -f $HOME/.local/bin/env ]] && source $HOME/.local/bin/env
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
