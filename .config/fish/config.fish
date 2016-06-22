# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/Users/stefanepenner/.config/omf"

set -x EDITOR nvim

fundle plugin 'edc/bass'

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

function fish_greeting
end

function conflicts
  git ls-files --unmerged | cut -f2 | uniq
end

function whatchanged
  set repo $argv[1]
  set range $argv[2]

  open https://github.com/$repo/compare/master@\{$range\}...master
end

function n
  env "NODE_NO_READLINE=1" rlwrap -S "> " node $args
end

function morning
  whatchanged emberjs/ember.js 1day
  whatchanged ember-cli/ember-cli 1day
  whatchanged emberjs/data 1day
  whatchanged tildeio/htmlbars 1day
  whatchanged v8/v8-git-mirror 1day
  whatchanged rust-lang/rust 1day
  whatchanged WebKit/webkit 1day
  whatchanged Microsoft/ChakraCore 1day
  whatchanged tc39/ecma262 1day
  whatchanged testem/testem 1day
  # list new issues / pr from the last day
end

function test262
  tools/run-tests.py --arch-and-mode=x64.release test262-es6 --download-data
end

sh ~/.config/fish/base16-3024.dark.sh
