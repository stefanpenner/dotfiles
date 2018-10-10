set -g FISH_NODE_ROOT $HOME/.config/node
set -g FISH_NODE_REMOTE "https://nodejs.org/download/release"

set -l os (uname -s)
set -l arch (uname -m)
set -l x (echo $os | tr '[A-Z]' '[a-z]')
set -l y (echo $arch | sed s/86_//)

set -g _node_current_platform "$x-$y"

function __echo-success -a message
  set_color green;
  printf "  ✓ ";
  set_color normal;
  echo "$message";
end

function __echo-failure -a message
  set_color red;
  printf "  ✗ ";
  set_color normal;
  echo "$message"
end

function node-setup
  mkdir -p $FISH_NODE_ROOT/{versions,default,tarballs,checksums,cache}
end

node-setup

if test -d $HOME/.config/node/default/bin
  set -gx PATH $HOME/.config/node/default/bin $PATH
end

# enable global yarn bins
if test -d $HOME/.yarn-config/global/node_modules/.bin
  set -gx PATH $HOME/.yarn-config/global/node_modules/.bin $PATH
end
