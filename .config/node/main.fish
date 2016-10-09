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
  set version $argv[1]
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

  rm -rf $target
  ln -s "$root/versions/$filename" $target
end

function node_ls
  for node in (ls "$root/versions")
    echo $node | cut -d '-' -f 2
  end
end

function node_ls_remote
  curl https://nodejs.org/download/release/index.json | jq -r '.[].version'
end

setup
# clean_node_version v6.7.0
# node_install v6.7.0
# node_install v4.7.0
# node_ls
# node_ls_remote

set -gx PATH $HOME/.config/node/current/bin $PATH
