# Shared zsh config — sourced by ~/.zshrc
# Dependencies:
#   brew install fzf fd bat bat-extras lsd direnv zsh-autosuggestions zsh-fast-syntax-highlighting zsh-history-substring-search
#   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/zsh/plugins/powerlevel10k

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

# --- History ---
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

# --- Shell options ---
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

# --- Completion system ---
fpath=(/opt/homebrew/share/zsh/site-functions ~/.zfunc $fpath)

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

# --- Key bindings ---
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word
bindkey '^[[Z' reverse-menu-complete

# --- Terminal title ---
function _set_terminal_title_precmd() {
  print -Pn '\e]2;%~\a'
}
function _set_terminal_title_preexec() {
  printf '\e]2;%s\a' "${1}"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _set_terminal_title_precmd
add-zsh-hook preexec _set_terminal_title_preexec

# --- Powerlevel10k ---
source ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Aliases ---
[[ -f /opt/homebrew/bin/lsd ]] && alias ls=/opt/homebrew/bin/lsd
alias lg=lazygit
alias man=/opt/homebrew/bin/batman

# --- fzf ---
eval "$(fzf --zsh)"

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

# --- direnv ---
eval "$(direnv hook zsh)"

# --- zsh-autosuggestions ---
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70"

# --- zsh-history-substring-search ---
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# --- zsh-fast-syntax-highlighting (must be last plugin) ---
source /opt/homebrew/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# --- Utility functions ---
function extract() {
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
