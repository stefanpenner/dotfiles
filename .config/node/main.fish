set FISH_NODE_ROOT $HOME/.config/node
set FISH_NODE_REMOTE "https://nodejs.org/download/release"

function node-setup
  mkdir -p $FISH_NODE_ROOT/{versions,default,tarballs,checksums,cache}
end

function node-start-again
  rm -rf $FISH_NODE_ROOT/{versions,default,tarballs,checksums,cache}
  node-setup
end

function _get_node_current_platform
  set -l os (uname -s)
  set -l arch (uname -m)
  set -l x (echo $os | tr '[A-Z]' '[a-z]')
  set -l y (echo $arch | sed s/86_//)

  echo "$x-$y"
end

set _node_current_platform (_get_node_current_platform)

function node-uninstall
  set -l _version $argv[1]
  set -l filename node-$_version-$_node_current_platform.tar.gz
  set -l tarball $FISH_NODE_ROOT/tarballs/$filename
  set -l target $FISH_NODE_ROOT/versions/node-$_version-$_node_current_platform/
  set -l checksum "$FISH_NODE_ROOT/checksums/$_version-SHASUMS256.txt"

  rm -rf $tarball $target $checksum
end

function node-get
  node-install $argv
end

function node-install
  set -l input_version $argv[1]
  set -l _version (node-version-match $input_version)

  if test -s $_version
    echo-failure "no such version: $input_version"
    return 1
  end

  echo " installing: node.version = $_version"

  set -l arch (uname -sm)
  set -l filename "node-$_version-$_node_current_platform.tar.gz"
  set -l tarball "$FISH_NODE_ROOT/tarballs/$filename"
  set -l target "$FISH_NODE_ROOT/versions/node-$_version-$_node_current_platform/"
  set -l shasumText "$FISH_NODE_ROOT/checksums/$_version-SHASUMS256.txt"

  if not test -e $tarball
    echo "$FISH_NODE_REMOTE/$_version/$filename"
    curl --fail --progress "$FISH_NODE_REMOTE/$_version/$filename" > "$tarball"
  end

  echo-success "downloaded"

  if not test -e $shasumText
    echo "$FISH_NODE_REMOTE/$_version/SHASUMS256.txt"
    curl --fail "$FISH_NODE_REMOTE/$_version/SHASUMS256.txt" > "$shasumText"
  end

  fish -c "cd $FISH_NODE_ROOT/tarballs/; and cat $shasumText | grep $filename | shasum -c - > /dev/null"

  echo-success "verified"

  if not test -e $target
    tar -C "$FISH_NODE_ROOT/versions"/ -zxf "$FISH_NODE_ROOT/tarballs/$filename"
  end

  echo-success "installed"
end

function echo-success
  set -l message $argv[1]

  set_color green;
  printf "  ✓ ";
  set_color normal;
  echo "$message";
end

function echo-failure
  set -l message $argv[1]

  set_color red;
  printf "  ✗ ";
  set_color normal;
  echo "$message"
end

function node-set
  set -l input_version $argv[1]
  set -l _version (node-version-match $input_version)
  set -l filename "node-$_version-$_node_current_platform/bin"

  if test -e "$FISH_NODE_ROOT/versions/$filename"
    set -gx PATH "$FISH_NODE_ROOT/versions/$filename" $PATH
    echo-success "node.current = $_version"
  else
    echo-failure  "node.current = $_version; not installed"
  end
end

function node-set-global
  set -l input_version $argv[1]
  set -l _version (node-version-match $input_version)
  set -l filename "node-$_version-$_node_current_platform/bin"
  set -l target  "$FISH_NODE_ROOT/default/bin"

  if test -e "$FISH_NODE_ROOT/versions/$filename"
    rm -rf $target
    ln -s "$FISH_NODE_ROOT/versions/$filename" $target
    set -gx PATH "$FISH_NODE_ROOT/versions/$filename" $PATH

    echo-success "node.global = $_version"
  else
    echo-failure  "node.current = $_version; not installed"
  end
end

function node-ls
  set -l _version "$argv[1]"
  for node in (ls "$FISH_NODE_ROOT/versions" | grep $_version)
    echo $node | cut -d '-' -f 2
  end
end

function node-version-match
  set -l _version "$argv[1]"
  node-ls-remote | grep $_version | sort | tail -n 1
end

function node-ls-remote-refresh
  rm $FISH_NODE_ROOT/cache/versions.json
  node-ls-remote
end

function node-ls-remote
  set -l _version "$argv[1]"
  if not test -e $FISH_NODE_ROOT/cache/versions.json
    curl https://nodejs.org/download/release/index.json 2> /dev/null > $FISH_NODE_ROOT/cache/versions.json
  else

  end

  cat $FISH_NODE_ROOT/cache/versions.json | jq -r '.[].version' | grep $_version
end

node-setup
# clean_node_version v6.7.0
# node-isntall v6.7.0
# node-isntall v4.7.0
# node-ls
# node-ls-remote

if test -f $HOME/.config/node/default/bind
  set -gx PATH $HOME/.config/node/default/bin $PATH
end

# enable global yarn bins
set -gx PATH $HOME/.yarn-config/global/node_modules/.bin $PATH
