# Shared zsh config — sourced by ~/.zshrc
# Dependencies:
#   brew install fzf fd bat bat-extras lsd direnv zsh-autosuggestions zsh-fast-syntax-highlighting zsh-history-substring-search
#   — or equivalent packages via apt/dnf/pacman
#   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/zsh/plugins/powerlevel10k

# --- Platform detection (run once) ---
if (( $+commands[brew] )); then
  _zsh_brew_prefix="${HOMEBREW_PREFIX:-$(brew --prefix)}"
else
  _zsh_brew_prefix=""
fi

# Candidate directories for zsh plugin/share files
# Local plugins dir first (for hermetic bundles), then system paths
_zsh_share_dirs=(
  $HOME/.config/zsh/plugins
  ${_zsh_brew_prefix:+$_zsh_brew_prefix/share}
  /usr/share
  /usr/local/share
)

# Source the first existing file from a list of candidates
_source_first() {
  local f
  for f in "$@"; do
    if [[ -f "$f" ]]; then
      source "$f"
      return 0
    fi
  done
  return 1
}

# --- Helpers ---
path_prepend() {
  local dir
  for dir in "$@"; do
    [[ -d "$dir" ]] || continue
    case ":${PATH}:" in
      *:"$dir":*) ;;
      *) export PATH="$dir:$PATH" ;;
    esac
  done
}

# --- Auto-install missing dependencies ---
_zsh_ensure_deps() {
  local missing=()
  local p10k_dir="$HOME/.config/zsh/plugins/powerlevel10k"

  # Commands
  local -A cmd_checks=(fzf fzf fd fd bat bat bat-extras batman lsd lsd direnv direnv)
  local pkg cmd
  for pkg cmd in "${(@kv)cmd_checks}"; do
    (( $+commands[$cmd] )) || missing+=("$pkg")
  done

  # Plugins — check across all share dirs
  local -A plugin_files=(
    zsh-autosuggestions          zsh-autosuggestions/zsh-autosuggestions.zsh
    zsh-fast-syntax-highlighting zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    zsh-history-substring-search zsh-history-substring-search/zsh-history-substring-search.zsh
  )
  local subpath found d
  for pkg subpath in "${(@kv)plugin_files}"; do
    found=false
    for d in $_zsh_share_dirs; do
      [[ -f "$d/$subpath" ]] && { found=true; break; }
    done
    $found || missing+=("$pkg")
  done

  local missing_p10k=false
  [[ ! -d "$p10k_dir" ]] && missing_p10k=true

  (( ${#missing} )) || $missing_p10k || return 0

  echo "zsh: missing dependencies:"
  printf '  %s\n' "${missing[@]}"
  $missing_p10k && echo "  powerlevel10k (git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $p10k_dir)"

  # Only auto-install via brew — package names vary too much across distros
  if (( ${#missing} )) && (( $+commands[brew] )); then
    read -q "reply?Install with brew now? [y/N] " || { echo; return 0; }
    echo
    echo "zsh: brew install ${missing[*]}"
    brew install "${missing[@]}"
  fi

  if $missing_p10k; then
    read -q "reply?Clone powerlevel10k now? [y/N] " || { echo; return 0; }
    echo
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
  fi
}

# --- Utility functions ---
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *)         echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# --- Section setup functions ---

_zsh_setup_history() {
  HISTFILE=$HOME/.zsh_history
  HISTSIZE=50000
  SAVEHIST=50000
  unsetopt SHARE_HISTORY
  setopt EXTENDED_HISTORY
  setopt HIST_IGNORE_DUPS
  setopt HIST_IGNORE_ALL_DUPS
  setopt HIST_FIND_NO_DUPS
  setopt HIST_IGNORE_SPACE
  setopt HIST_VERIFY
  setopt APPEND_HISTORY
  setopt INC_APPEND_HISTORY
}

_zsh_setup_options() {
  setopt AUTO_CD
  setopt CORRECT
  setopt GLOB_COMPLETE
  setopt NUMERIC_GLOB_SORT
  setopt EXTENDED_GLOB
  setopt GLOB_STAR_SHORT
  setopt COMPLETE_IN_WORD
  setopt AUTO_MENU
  setopt AUTO_LIST
  setopt AUTO_PARAM_SLASH
  setopt LIST_PACKED
  setopt LIST_ROWS_FIRST
  setopt AUTO_PUSHD
  setopt PUSHD_IGNORE_DUPS
  setopt PUSHD_MINUS
}

_zsh_setup_completion() {
  local d
  for d in $_zsh_share_dirs; do
    [[ -d "$d/zsh/site-functions" ]] && fpath=("$d/zsh/site-functions" $fpath)
    [[ -d "$d/zsh/vendor-completions" ]] && fpath=("$d/zsh/vendor-completions" $fpath)
  done
  fpath=(~/.zfunc $fpath)

  zstyle ':completion:*' menu select
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
  zstyle ':completion:*' use-cache yes
  zstyle ':completion:*' cache-path "$HOME/.cache/zsh-completion"
  zstyle ':completion:*' rehash true
  zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
  zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

  autoload -Uz compinit
  if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
}

_zsh_setup_keybindings() {
  bindkey '^[[1;5C' forward-word
  bindkey '^[[1;5D' backward-word
  bindkey '^H' backward-kill-word
  bindkey '^[[3;5~' kill-word
  bindkey '^[[Z' reverse-menu-complete
}

_zsh_setup_terminal_title() {
  function _set_terminal_title_precmd() {
    print -Pn '\e]2;%~\a'
  }
  function _set_terminal_title_preexec() {
    printf '\e]2;%s\a' "${1}"
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _set_terminal_title_precmd
  add-zsh-hook preexec _set_terminal_title_preexec
}

_zsh_setup_prompt() {
  [[ -f ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme ]] && \
    source ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
}

_zsh_setup_aliases() {
  (( $+commands[lsd] )) && alias ls=lsd
  alias lg=lazygit
  (( $+commands[batman] )) && alias man=batman
  (( $+commands[nvim] )) && alias vim=nvim
}

_zsh_setup_paths() {
  path_prepend "$HOME/.local/bin"
  path_prepend "$HOME/.local/go/bin"
  path_prepend "$HOME/.local/git/bin"
  [[ -d "$HOME/.local/git/libexec/git-core" ]] && \
    export GIT_EXEC_PATH="$HOME/.local/git/libexec/git-core"
  path_prepend "$HOME/.local/zsh/bin"

  # Add zsh functions from dotpack (static zsh needs fpath override)
  local d
  for d in "$HOME/.local/zsh/share/zsh"/*/functions(N); do
    fpath=("$d" $fpath)
  done
  [[ -d "$HOME/.local/zsh/share/zsh/site-functions" ]] && \
    fpath=("$HOME/.local/zsh/share/zsh/site-functions" $fpath)
}

_zsh_setup_fzf() {
  local fzf_base=""
  local candidate
  for candidate in \
    $HOME/.config/zsh/plugins/fzf \
    ${_zsh_brew_prefix:+$_zsh_brew_prefix/opt/fzf/shell} \
    /usr/share/fzf \
    /usr/share/doc/fzf/examples; do
    if [[ -d "$candidate" ]]; then
      fzf_base="$candidate"
      break
    fi
  done

  if [[ -n "$fzf_base" ]]; then
    [[ -f "$fzf_base/key-bindings.zsh" ]] && source "$fzf_base/key-bindings.zsh"
    [[ -f "$fzf_base/completion.zsh" ]]   && source "$fzf_base/completion.zsh"
  fi

  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_DEFAULT_OPTS=" \
    --color=bg+:#283457,bg:#16161e,spinner:#bb9af7,hl:#7aa2f7 \
    --color=fg:#c0caf5,header:#7aa2f7,info:#7dcfff,pointer:#bb9af7 \
    --color=marker:#9ece6a,fg+:#c0caf5,prompt:#7dcfff,hl+:#7aa2f7 \
    --layout=reverse --border --height=40%"

  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_ALT_C_OPTS="--preview 'lsd --tree --depth 2 --color always {}'"

  export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:3:wrap"
}

_zsh_setup_direnv() {
  (( $+commands[direnv] )) && eval "$(direnv hook zsh)"
}

_zsh_setup_plugins() {
  # zsh-autosuggestions
  _source_first ${_zsh_share_dirs/%//zsh-autosuggestions/zsh-autosuggestions.zsh}
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70"

  # zsh-history-substring-search
  _source_first ${_zsh_share_dirs/%//zsh-history-substring-search/zsh-history-substring-search.zsh}
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down

  # zsh-fast-syntax-highlighting (must be last plugin)
  _source_first ${_zsh_share_dirs/%//zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh}
}

# --- Init ---
_zsh_init() {
  if [[ -o interactive ]]; then
    _zsh_ensure_deps
  fi

  _zsh_setup_paths
  _zsh_setup_history
  _zsh_setup_options
  _zsh_setup_completion
  _zsh_setup_keybindings
  _zsh_setup_terminal_title
  _zsh_setup_prompt
  _zsh_setup_aliases
  _zsh_setup_fzf
  _zsh_setup_direnv
  _zsh_setup_plugins
}

_zsh_init
