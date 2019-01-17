# echo "You can do anything... as long as there's something more important your not doing"
function fish_title
end

function reload
  set -l config (status -f)
  echo "reloading: $config"
  source $config
end

# Ensure fisherman and plugins are installed
if not test -f $HOME/.config/fish/functions/fisher.fish
  echo "==> Fisherman not found.  Installing."
  curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
  fisher
end

set -x EDITOR nvim
if test -d $HOME/.src/google/depot_tools
  set -gx PATH $HOME/src/google/depot_tools $PATH
end

if test -d /Applications/Racket\ v7.1/bin/
  set -gx PATH /Applications/Racket\ v7.1/bin/ $PATH
end

if test -d $HOME/.notion
  set -gx NOTION_HOME $HOME/.notion
  set -gx PATH $NOTION_HOME/bin $PATH
  set -gx PATH $NOTION_HOME/shim $PATH
end

if test -d $HOME/src/google/depot_tools/
  set -gx PATH $HOME/src/google/depot_tools/ $PATH
end

if test -d $HOME/.local/bin/
  set -gx PATH $HOME/.local/bin $PATH
end

if test -d $HOME/src/carp-lang/Carp/
  set -gx CARP_DIR $HOME/carp-lang/Carp/
end

function pwdc
  pwd | pbcopy
  echo (pwd)
end

function http
  ruby -run -e httpd -- --port 8888 .
end

function watchman-reset
  for root in (watchman watch-list | jq '.roots | .[]')
    watchman watch-del (echo $root | sed 's/"//g')
  end
end

function conflicts
  git ls-files --unmerged | cut -f2 | uniq
end

function n
  env "NODE_NO_READLINE=1" rlwrap -S "> " node $args
end

function test262
  tools/run-tests.py --arch-and-mode=x64.release test262-es6 --download-data
end

function npm-latest
  npm version > /dev/null
  npm info --json "$argv[1]" | jq -r '.version'
end

function rb-diff
  set path = $TMPDIR/$argv[1].diff
  wget -O $path https://rb.corp.linkedin.com/r/$argv[1]/diff/raw
  nvim $path
end

function rb-get
  wget https://rb.corp.linkedin.com/r/$argv[1]/diff/raw
end

function n
  command nvim $argv
end

function nzf
  fzf > $TMPDIR/fzf.result; and n (cat $TMPDIR/fzf.result)
end

function d8
  eval $HOME/src/google/v8/out/native/d8 $argv
end

function d8_debug
  eval $HOME/src/google/v8/out/x64.debug/d8 $argv
end


function ch
  eval $HOME/src/MicroSoft/ChakraCore/out/Test/ch $argv
end

function dot-open
  set -l input $argv[1]
  set -l tmp $TMPDIR/dot-open.out.png
  echo $input
  echo $tmp
  dot $input -Tpng > $tmp
  open $tmp
  return $tmp
end

function setup-depot-tools
  set -l path $HOME/src/google/depot_tools/
  if test -e $path
  else
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git $path
  end
end

function setup-v8
  setup-depot-tools
  if test -e $HOME/src/google/v8
  else
    cd src/google/
    fetch v8
  end
end

function node-debug
  kill -9 (lsof -ti tcp:5858) 2> /dev/null
  node debug $argv
end

function html2rtf
  textutil -convert rtf -stdin -stdout | pbcopy
end

function release
  set -l tag $argv[1]

  if test -f package.json
    jq ".version=\"$tag\"" < package.json | sponge package.json
    git add -f ./package.json
  end

  if test -d .git
    git commit -m "release v$tag 🎉"
    git tag "v$tag"
    set -l branch (git branch | grep '^\*' | sed 's/* //')
    git push origin "$branch" "v$tag"
  end

  if test -f package.json
    npm publish
  end

  echo "released as v$tag 🎉" | pbcopy
end

if test -f $HOME/.config/fish/nix.fish
  source $HOME/.config/fish/nix.fish
end

function start-benchmarking
  sudo launchctl unload -w /Library/LaunchDaemons/com.crashplan.engine.plist
  sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
  sudo launchctl unload -w /Library/LaunchDaemons/com.jamfsoftware.task.1.plist
  sudo launchctl unload -w /Library/LaunchDaemons/com.jamfsoftware.jamf.daemon.plist
end

function stop-benchmarking
  sudo launchctl load -w /Library/LaunchDaemons/com.crashplan.engine.plist
  sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
  sudo launchctl load -w /Library/LaunchDaemons/com.jamfsoftware.task.1.plist
  sudo launchctl load -w /Library/LaunchDaemons/com.jamfsoftware.jamf.daemon.plist
end

function das-test
 mint wc-test -d "Strength does not come from winning" &
 mint wc-test -d "Your struggles develop your strengths" &
 mint wc-test -d "When you go through hardships and decide not to surrender, that is strength" &

 wait
end

# Base16 Shell
if status --is-interactive
    eval sh $HOME/.config/base16-shell/scripts/base16-oceanicnext.sh
end
# eval sh $HOME/.config/fish/base16-3024.dark.sh


function tar-pipe
  set -l from_folder $argv[1]
  set -l to_ssh $argv[2]
  set -l to_folder $argv[3]

  echo $from_folder
  echo $to_ssh
  echo $to_folder

  tar cpf - $from_folder | pv | ssh $to_ssh "tar xpf - -C $to_folder"
end

if test -d /export/content/linkedin/etc/fish
  set -g fish_complete_path /export/content/linkedin/etc/fish $fish_complete_path
end

if test -d /usr/local/linkedin/etc/fish
  set -g fish_complete_path /usr/local/linkedin/etc/fish $fish_complete_path
end

complete --command "git co" --wraps "git checkout"

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

function notion
  $HOME/.notion/notion $argv
end

if test -d $HOME/.cargo/
  set -g fish_user_paths $HOME/.cargo/bin $fish_user_paths
end
