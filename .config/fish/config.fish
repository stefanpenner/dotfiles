# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/Users/stefanepenner/.config/omf"

set -x EDITOR nvim

fundle plugin 'edc/bass'

function nom
  echo "reseting local node_modules..."
  rm -rf node_modules
  and npm cache clear
  and npm i --no-optional
end

function bom
  echo "reseting local bower_components..."
  rm -rf bower_components
  and bower cache clean
  and bower i
end

function pwdc
  pwd | pbcopy
  echo (pwd)
end

function http
  ruby -run -e httpd -- --port 8888 .
end

function n
  nvim
end

function watchman-reset
  for root in (watchman watch-list | jq '.roots | .[]')
    watchman watch-del (echo $root | sed 's/"//g')
  end
end

function fish_greeting
end

alias l  "osascript ~/.termtile/tile.scpt left"
alias ul "osascript ~/.termtile/tile.scpt up left"
alias ur "osascript ~/.termtile/tile.scpt up right"
alias dl "osascript ~/.termtile/tile.scpt down left"
alias dr "osascript ~/.termtile/tile.scpt down right"
alias ll "osascript ~/.termtile/tile.scpt left"
alias r  "osascript ~/.termtile/tile.scpt right"
alias u  "osascript ~/.termtile/tile.scpt up"
alias d  "osascript ~/.termtile/tile.scpt down"

function conflicts
  git ls-files --unmerged | cut -f2 | uniq
end

#test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

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

function fvm
  bass source ~/.nvm/nvm.sh ';' nvm $argv
end

function bass
  if test $argv[1] = '-d'
    set __bass_debug
    set __bash_args $argv[2..-1]
  else
    set __bash_args $argv
  end

  set -l __script (python (dirname (status -f))/__bass.py $__bash_args)
  if test $__script = '__error'
    echo "Bass encountered an error!"
  else
    source $__script
    if set -q __bass_debug
      cat $__script
    end
    rm -f $__script
  end
end

test -s /Users/stefanpenner/.nvm-fish/nvm.fish; and source /Users/stefanpenner/.nvm-fish/nvm.fish

function npmo
  npm --cache-min 9999999 $args
end

function git-create
  curl -u 'stefanpenner' https://api.github.com/user/repos -d "{\"name\":\"$argv[1]\"}"
end
