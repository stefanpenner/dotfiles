set root $HOME/.config/node
set remote "https://nodejs.org/download/release"

function setup
  mkdir -p $root/{versions,current,tarballs}
end

function clean_node_version
  set version $argv[1]
  set filename node-$version-darwin-x64.tar.gz
  set tarball $root/tarballs/$filename
  set target $root/versions/node-$version-darwin-x64/

  rm -rf $tarball $target
end

function node_install
  set input_version $argv[1]
  set version (node_version_best_match $input_version)

  if test -s $version
    echo "no such version: $input_version"
    return
  end

  set filename "node-$version-darwin-x64.tar.gz"
  set tarball "$root/tarballs/$filename"
  set target "$root/versions/node-$version-darwin-x64/"

  if not test -e $tarball
    curl --progress "$remote/$version/$filename" > "$tarball"
  end

  if not test -e $target
    tar -C "$root/versions"/ -zxf "$root/tarballs/$filename"
  end

  node_set_version $version
end

function node_set_version
  set version "$argv[1]"
  set filename "node-$version-darwin-x64/bin"
  set target  "$root/current/bin"

  echo $version

  rm -rf $target
  ln -s "$root/versions/$filename" $target
end

function node_ls
  set version "$argv[1]"
  for node in (ls "$root/versions" | grep $version)
    echo $node | cut -d '-' -f 2
  end
end

function node_version_best_match
  set version "$argv[1]"
  node_ls_remote | grep $version | sort | tail -n 1
end

function node_ls_remote
  set version "$argv[1]"
  curl https://nodejs.org/download/release/index.json 2> /dev/null | jq -r '.[].version' | grep $version
end

setup
# clean_node_version v6.7.0
# node_install v6.7.0
# node_install v4.7.0
# node_ls
# node_ls_remote

set -gx PATH $HOME/.config/node/current/bin $PATH
