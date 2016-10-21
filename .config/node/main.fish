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

function node_install
  set input_version $argv[1]
  set _version (node_version_best_match $input_version)

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

  node_set_version $_version
end

function node_set_version
  set _version "$argv[1]"
  set filename "node-$_version-darwin-x64/bin"
  set target  "$root/current/bin"

  echo $_version

  rm -rf $target
  ln -s "$root/versions/$filename" $target
end

function node_ls
  set _version "$argv[1]"
  for node in (ls "$root/versions" | grep $_________version)
    echo $node | cut -d '-' -f 2
  end
end

function node_version_best_match
  set _version "$argv[1]"
  node_ls_remote | grep $_version | sort | tail -n 1
end

function node_ls_remote
  set _version "$argv[1]"
  curl https://nodejs.org/download/release/index.json 2> /dev/null | jq -r '.[].version' | grep $_version
end

setup
# clean_node_version v6.7.0
# node_install v6.7.0
# node_install v4.7.0
# node_ls
# node_ls_remote

set -gx PATH $HOME/.config/node/current/bin $PATH
