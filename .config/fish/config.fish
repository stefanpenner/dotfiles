echo "You can do anything... as long as there's something more important your not doing"

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

if test -d $HOME/.cargo/bin/
  set -gx PATH $HOME/.cargo/bin $PATH
end

if test -d $HOME/src/google/depot_tools/
  set -gx PATH $HOME/src/google/depot_tools/ $PATH
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

eval sh $HOME/.config/fish/base16-3024.dark.sh

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
    git push origin master "v$tag"
  end
end
