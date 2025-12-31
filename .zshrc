export XDG_CONFIG_HOME=$HOME/.config

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Helper function to add paths only if they don't already exist
# Warns if a duplicate is detected to help catch configuration issues
path_prepend() {
  local dir caller_info path_index=0
  caller_info="${funcfiletrace[1]:-unknown}"
  for dir in "$@"; do
    [[ -d "$dir" ]] || continue
    case ":${PATH}:" in
      *:"$dir":*)
        # Find which position in PATH (1-indexed)
        path_index=$(echo ":$PATH:" | tr ':' '\n' | grep -n "^$dir$" | head -1 | cut -d: -f1)
        echo "⚠️  Warning: Duplicate PATH entry detected: $dir" >&2
        echo "   Called from: $caller_info" >&2
        echo "   Already exists at position $path_index in PATH" >&2
        ;;
      *)
        export PATH="$dir:$PATH"
        ;;
    esac
  done
}

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim

# History configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_IGNORE_DUPS       # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicates
setopt HIST_FIND_NO_DUPS      # Don't show duplicates in search
setopt HIST_IGNORE_SPACE      # Ignore commands starting with space
setopt HIST_VERIFY            # Show command before executing
setopt APPEND_HISTORY         # Append to history file
setopt INC_APPEND_HISTORY     # Append immediately, not on exit

# Completion improvements
setopt COMPLETE_IN_WORD        # Complete from both ends
setopt AUTO_MENU              # Show completion menu on tab
setopt AUTO_LIST              # List choices on ambiguous completion
setopt AUTO_PARAM_SLASH       # Add trailing slash to directories
setopt COMPLETE_ALIASES       # Complete aliases

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case, to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="zsh-tokyonight/tokyonight"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  # zsh-autosuggestions
  fzf
  zsh_codex
)

bindkey '^X' create_completion

source $ZSH/oh-my-zsh.sh

# User configuration
# export VOLTA_HOME="$HOME/.volta"
# export PATH="$VOLTA_HOME/bin:$PATH"
# export PATH="$HOME/.config/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# PATH configuration - using helper to avoid duplicates
path_prepend \
  "$HOME/bin" \
  "$HOME/go/bin" \
  "$HOME/.fly/bin" \
  "$HOME/.bun/bin" \
  "$HOME/.local/bin"

# Tool-specific configurations
export FLYCTL_INSTALL="$HOME/.fly"
export BUN_INSTALL="$HOME/.bun"

# Aliases
[[ -f /opt/homebrew/bin/lsd ]] && alias ls=/opt/homebrew/bin/lsd
alias lg=lazygit

# Load environment variables (API keys, etc.)
[[ -f ~/.env ]] && source ~/.env

# Load local environment
[[ -f $HOME/.local/bin/env ]] && source $HOME/.local/bin/env

# Zsh completions - use cache for faster startup
fpath+=~/.zfunc
# Only run full compinit check if dump is older than 24 hours (faster startup)
autoload -Uz compinit
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit -C  # skip check if dump is fresh (< 24h old)
else
  compinit     # full check if dump is old or missing
fi

# Functions
owu() {
  DATA_DIR=~/.open-webui uvx --python 3.11 open-webui@latest serve
}

# Doppler shortcuts
alias drun='doppler run --'
alias dsh='doppler run --project aiur --config=workstation -- $SHELL'
alias denv='doppler secrets download --no-file --format env'

# SSH agent socket
export SSH_AUTH_SOCK=$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

# Bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
