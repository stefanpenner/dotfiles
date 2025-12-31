export XDG_CONFIG_HOME=$HOME/.config

# Ghostty terminal optimizations
if [[ "$TERM_PROGRAM" == "Ghostty" ]] || [[ -n "$GHOSTTY_VERSION" ]]; then
  # Ghostty supports true color and modern terminal features
  export COLORTERM=truecolor
  # Optimize for Ghostty's GPU acceleration
  export TERM=xterm-256color
fi

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

# Modern zsh options for better UX
setopt AUTO_CD                # cd by typing directory name if it's not a command
setopt CORRECT                # Spelling correction for commands
setopt CORRECT_ALL            # Spelling correction for arguments
setopt GLOB_COMPLETE          # Complete globs
setopt NUMERIC_GLOB_SORT      # Sort numeric filenames numerically
setopt EXTENDED_GLOB          # Enable extended globbing patterns
setopt GLOB_STAR_SHORT        # **/*.txt expands to all .txt files recursively

# Completion improvements
setopt COMPLETE_IN_WORD        # Complete from both ends
setopt AUTO_MENU              # Show completion menu on tab
setopt AUTO_LIST              # List choices on ambiguous completion
setopt AUTO_PARAM_SLASH       # Add trailing slash to directories
setopt COMPLETE_ALIASES       # Complete aliases
setopt MENU_COMPLETE          # Insert first match immediately
setopt LIST_PACKED            # Use compact completion lists
setopt LIST_ROWS_FIRST        # Matches are sorted in rows

# Modern completion system
zstyle ':completion:*' menu select                              # Use menu selection
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case-insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colorize completions
zstyle ':completion:*' group-name ''                            # Group completions
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'            # Format group headers
zstyle ':completion:*' use-cache yes                            # Use completion cache
zstyle ':completion:*' cache-path "$HOME/.cache/zsh-completion"  # Cache location
zstyle ':completion:*' rehash true                              # Auto-rehash commands
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'         # Format descriptions
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

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

# Oh My Zsh update configuration
zstyle ':omz:update' mode reminder  # remind me to update when it's time
zstyle ':omz:update' frequency 7    # check for updates weekly

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
# Modern essential plugins:
#   - git: Git aliases and functions
#   - zsh-autosuggestions: Command suggestions based on history (install: git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions)
#   - zsh-syntax-highlighting: Syntax highlighting (install: git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting)
#   - fzf: Fuzzy finder integration
#   - zsh_codex: AI code completion
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
  zsh_codex
)

bindkey '^X' create_completion

source $ZSH/oh-my-zsh.sh

# Modern plugin configurations (load after oh-my-zsh)
# zsh-autosuggestions configuration
if [[ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)  # Use both history and completion
  ZSH_AUTOSUGGEST_USE_ASYNC=true                  # Async suggestions for better performance
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'          # Subtle highlight color
  bindkey '^ ' autosuggest-accept                 # Accept suggestion with Ctrl+Space
  bindkey '^f' autosuggest-accept                 # Accept suggestion with Ctrl+f
fi

# zsh-syntax-highlighting configuration (must be last)
if [[ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]]; then
  # Load after all other plugins
  source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  # Customize highlight styles
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
  ZSH_HIGHLIGHT_STYLES[default]='none'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
  ZSH_HIGHLIGHT_STYLES[command]='fg=green'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta'
  ZSH_HIGHLIGHT_STYLES[function]='fg=yellow'
  ZSH_HIGHLIGHT_STYLES[path]='fg=blue'
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue,bold'
fi

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

# Modern zsh completions - optimized for performance
fpath+=~/.zfunc

# Create cache directory if it doesn't exist
[[ -d "$HOME/.cache/zsh-completion" ]] || mkdir -p "$HOME/.cache/zsh-completion"

# Only run full compinit check if dump is older than 24 hours (faster startup)
# This significantly speeds up shell initialization
autoload -Uz compinit
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit -C -d "$HOME/.cache/zsh-completion/.zcompdump"  # skip check if dump is fresh (< 24h old)
else
  compinit -d "$HOME/.cache/zsh-completion/.zcompdump"      # full check if dump is old or missing
fi

# Modern key bindings for better navigation
bindkey '^[[1;5C' forward-word          # Ctrl+Right: forward word
bindkey '^[[1;5D' backward-word         # Ctrl+Left: backward word
bindkey '^H' backward-kill-word         # Ctrl+Backspace: kill word
bindkey '^[[3;5~' kill-word             # Ctrl+Delete: kill word
bindkey '^[[Z' reverse-menu-complete    # Shift+Tab: reverse menu complete

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
