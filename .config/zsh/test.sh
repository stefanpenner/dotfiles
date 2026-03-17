#!/bin/bash
set -euo pipefail

pass=0 fail=0

check() {
  local desc=$1; shift
  if "$@" >/dev/null 2>&1; then
    echo "  ✓ $desc"
    pass=$((pass + 1))
  else
    echo "  ✗ $desc"
    fail=$((fail + 1))
  fi
}

# helper: source rc.zsh then run a zsh expression
zrc() {
  zsh -c "source '$DIR/rc.zsh'; $1"
}

DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Syntax"
check "rc.zsh parses"      zsh -n "$DIR/rc.zsh"
check ".zshrc parses"      zsh -n "$DIR/../../.zshrc"

echo "Sourcing"
check "rc.zsh sources cleanly" zrc "true"

echo "Platform detection"
check "_zsh_share_dirs set"    zrc '(( ${#_zsh_share_dirs} > 0 ))'
check "_source_first defined"  zrc "typeset -f _source_first >/dev/null"

echo "Functions defined"
for fn in path_prepend extract _zsh_ensure_deps \
          _zsh_setup_history _zsh_setup_options _zsh_setup_completion \
          _zsh_setup_keybindings _zsh_setup_terminal_title _zsh_setup_prompt \
          _zsh_setup_aliases _zsh_setup_fzf _zsh_setup_direnv _zsh_setup_plugins \
          _zsh_init; do
  check "$fn" zrc "typeset -f $fn >/dev/null"
done

echo "History"
check "HISTFILE set"        zrc '[[ "$HISTFILE" == "$HOME/.zsh_history" ]]'
check "HISTSIZE=50000"      zrc '[[ "$HISTSIZE" == 50000 ]]'
check "EXTENDED_HISTORY"    zrc '[[ -o EXTENDED_HISTORY ]]'
check "HIST_IGNORE_DUPS"    zrc '[[ -o HIST_IGNORE_DUPS ]]'
check "APPEND_HISTORY"      zrc '[[ -o APPEND_HISTORY ]]'
check "no SHARE_HISTORY"    zrc '[[ ! -o SHARE_HISTORY ]]'

echo "Shell options"
check "AUTO_CD"             zrc '[[ -o AUTO_CD ]]'
check "EXTENDED_GLOB"       zrc '[[ -o EXTENDED_GLOB ]]'
check "AUTO_PUSHD"          zrc '[[ -o AUTO_PUSHD ]]'
check "CORRECT"             zrc '[[ -o CORRECT ]]'

echo "Completion"
check "fpath has site-functions" zrc '[[ "${fpath[*]}" == *site-functions* ]]'
check "fpath has ~/.zfunc"       zrc '[[ "${fpath[*]}" == *.zfunc* ]]'

echo "Aliases"
check "lg=lazygit"          zrc '[[ "$(alias lg)" == *lazygit* ]]'

echo "fzf"
check "FZF_DEFAULT_COMMAND" zrc '[[ -n "$FZF_DEFAULT_COMMAND" ]]'
check "FZF_DEFAULT_OPTS"    zrc '[[ -n "$FZF_DEFAULT_OPTS" ]]'

echo "Plugins"
check "ZSH_AUTOSUGGEST_STRATEGY" zrc '[[ "${ZSH_AUTOSUGGEST_STRATEGY[*]}" == "history completion" ]]'

echo "Portability"
check "no hardcoded /opt/homebrew in functions" \
  bash -c '! grep -n "/opt/homebrew" "$1" | grep -v "^#"' _ "$DIR/rc.zsh"

echo "Startup time"
elapsed=$(zsh -ic 'echo $SECONDS; exit' 2>/dev/null || echo 999)
ms=$(printf '%.0f' "$(echo "$elapsed * 1000" | bc)")
if [ "$ms" -lt 200 ]; then
  echo "  ✓ interactive startup ${ms}ms (< 200ms)"
  pass=$((pass + 1))
else
  echo "  ✗ interactive startup ${ms}ms (>= 200ms)"
  fail=$((fail + 1))
fi

echo ""
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
