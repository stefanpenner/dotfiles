set root $HOME/.config/node
set remote "https://nodejs.org/download/release"

function setup
  mkdir -p $root/{versions,current,tarballs}
end

function clean_node_version
  set _version $argv[1]
  set filename node-$_version-darwin-x64.tar.gz
  set tarball $root/tarballs/$filename
  set target $root/versions/node-$_version-darwin-x64/

  rm -rf $tarball $target
end

function node-install
  set input_version $argv[1]
  set _version (node-version-match $input_version)

  if test -s $_version
    echo "no such version: $input_version"
    return
  end

  set arch (uname -sm)
  set filename "node-$_version-darwin-x64.tar.gz"
  set tarball "$root/tarballs/$filename"
  set target "$root/versions/node-$_version-darwin-x64/"
  if not test -e $tarball
    curl --fail --progress "$remote/$_version/$filename" > "$tarball"
  end

  if not test -e $target
    tar -C "$root/versions"/ -zxf "$root/tarballs/$filename"
  end

  node-set-default-version $_version
end

function node-set-default-version
  set _version "$argv[1]"
  set filename "node-$_version-darwin-x64/bin"
  set target  "$root/current/bin"

  echo $_version

  rm -rf $target
  ln -s "$root/versions/$filename" $target
end

function node-ls
  set _version "$argv[1]"
  for node in (ls "$root/versions" | grep $_version)
    echo $node | cut -d '-' -f 2
  end
end

function node-version-match
  set _version "$argv[1]"
  node-ls-remote | grep $_version | sort | tail -n 1
end

function node-ls-remote
  set _version "$argv[1]"
  curl https://nodejs.org/download/release/index.json 2> /dev/null | jq -r '.[].version' | grep $_version
end

setup
# clean_node_version v6.7.0
# node-isntall v6.7.0
# node-isntall v4.7.0
# node-ls
# node-ls-remote

set -gx PATH $HOME/.config/node/current/bin $PATH
