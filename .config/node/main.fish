set root $HOME/.config/node
set remote "https://nodejs.org/download/release"

function setup
  mkdir -p $root/{versions,default,tarballs}
end

function clean_node_version
  set -l version $argv[1]
  set -l filename node-$version-darwin-x64.tar.gz
  set -l tarball $root/tarballs/$filename
  set -l target $root/versions/node-$version-darwin-x64/

  rm -rf $tarball $target
end

function node-install
  set -l input_version $argv[1]
  set -l version (node-version-match $input_version)

  if test -s $version
    echo "no such version: $input_version"
    return
  end

  set -l arch (uname -sm)
  set -l filename "node-$version-darwin-x64.tar.gz"
  set -l tarball "$root/tarballs/$filename"
  set -l target "$root/versions/node-$version-darwin-x64/"
  if not test -e $tarball
    curl --fail --progress "$remote/$_ersion/$filename" > "$tarball"
  end

  if not test -e $target
    tar -C "$root/versions"/ -zxf "$root/tarballs/$filename"
  end
end

function node-set
  set -l input_version $argv[1]
  set -l version (node-version-match $input_version)
  set -l filename "node-$version-darwin-x64/bin"

  echo $version

  set -gx PATH "$root/versions/$filename" $PATH
end

function node-set-default
  set -l input_version $argv[1]
  set -l version (node-version-match $input_version)
  set -l filename "node-$version-darwin-x64/bin"
  set -l target  "$root/default/bin"

  echo $version

  rm -rf $target
  ln -s "$root/versions/$filename" $target
  set -gx PATH "$root/versions/$filename" $PATH
end

function node-ls
  set -l version "$argv[1]"
  for node in (ls "$root/versions" | grep $version)
    echo $node | cut -d '-' -f 2
  end
end

function node-version-match
  set -l version "$argv[1]"
  node-ls-remote | grep $version | sort | tail -n 1
end

function node-ls-remote
  set -l version "$argv[1]"
  curl https://nodejs.org/download/release/index.json 2> /dev/null | jq -r '.[].version' | grep $version
end

setup
# clean_node_version v6.7.0
# node-isntall v6.7.0
# node-isntall v4.7.0
# node-ls
# node-ls-remote

set -gx PATH $HOME/.config/node/default/bin $PATH
