#!/bin/bash

GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RESET="\033[0m"
CHECK="✔" # Checkmark
CROSS="✘" # Cross
ARROW="➤" # Arrow

REPOS=(
  "neovim/neovim"
  "yetone/avante.nvim"
  "golang/go"
  "bazelbuild/bazel"
  "bazelbuild/bazel-gazelle"
)

XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
LAST_CHECK_FILE="$XDG_STATE_HOME/github_review/last_check"

# Ensure directory exists
mkdir -p "$(dirname "$LAST_CHECK_FILE")"
CURRENT_TIME=$(date +%s)

if [[ -f "$LAST_CHECK_FILE" ]]; then
  LAST_CHECK=$(cat "$LAST_CHECK_FILE")
else
  LAST_CHECK=$((CURRENT_TIME - (4 * 86400)))
  echo "$CURRENT_TIME" >"$LAST_CHECK_FILE"
fi

# Calculate exact days since last check (rounded up)
DAYS_DIFF=$(((CURRENT_TIME - LAST_CHECK + 86399) / 86400)) # Adding 86399 to round up
START="${DAYS_DIFF}day"

# Update last check time
echo "$CURRENT_TIME" >"$LAST_CHECK_FILE"

if ! command -v jq &>/dev/null || ! command -v curl &>/dev/null; then
  printf "${RED}${CROSS} Error: Missing dependencies. Please install jq and curl.${RESET}\n"
  echo "Install on macOS with: brew install jq curl"
  exit 1
fi

get_default_branch() {
  local repo=$1
  curl -s "https://api.github.com/repos/$repo" | jq -r .default_branch 2>/dev/null
}

aerospace workspace r
{
  for REPO in "${REPOS[@]}"; do
    DEFAULT_BRANCH=$(get_default_branch "$REPO")
    if [[ -z "$DEFAULT_BRANCH" || "$DEFAULT_BRANCH" == "null" ]]; then
      continue
    fi
    echo "https://github.com/$REPO/compare/$DEFAULT_BRANCH@{${START}}...${DEFAULT_BRANCH}"
  done
} | xargs -I {} open -na "Google Chrome" --args --new-window {}

printf "${GREEN}${CHECK} Done!${RESET}\n"
