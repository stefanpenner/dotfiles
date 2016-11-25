set root $HOME/.config/node
set remote "https://nodejs.org/download/release"

function node-setup
  mkdir -p $root/{versions,default,tarballs,checksums,cache}
end

function node-start-again
  rm -rf $root/{versions,default,tarballs,checksums,cache}
  node-setup
end

function node-uninstall
  set -l version $argv[1]
  set -l filename node-$version-darwin-x64.tar.gz
  set -l tarball $root/tarballs/$filename
  set -l target $root/versions/node-$version-darwin-x64/
  set -l checksum "$root/checksums/$version-SHASUMS256.txt"

  rm -rf $tarball $target $checksum
end

function node-install
  set -l input_version $argv[1]
  set -l version (node-version-match $input_version)

  if test -s $version
    echo-failure "no such version: $input_version"
    return 1
  end

  echo " installing: node.version = $version"

  set -l arch (uname -sm)
  set -l filename "node-$version-darwin-x64.tar.gz"
  set -l tarball "$root/tarballs/$filename"
  set -l target "$root/versions/node-$version-darwin-x64/"
  set -l shasumText "$root/checksums/$version-SHASUMS256.txt"

  if not test -e $tarball
    curl --fail --progress "$remote/$version/$filename" > "$tarball"
  end

  echo-success "downloaded"

  if not test -e $shasumText
    curl --fail "$remote/$version/SHASUMS256.txt" > "$shasumText"
  end

  fish -c "cd $root/tarballs/; and cat $shasumText | grep $filename | shasum -c - > /dev/null"

  echo-success "verified"

  if not test -e $target
    tar -C "$root/versions"/ -zxf "$root/tarballs/$filename"
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
  set -l version (node-version-match $input_version)
  set -l filename "node-$version-darwin-x64/bin"

  set -gx PATH "$root/versions/$filename" $PATH

  echo-success "node.current = $version"
end

function node-set-global
  set -l input_version $argv[1]
  set -l version (node-version-match $input_version)
  set -l filename "node-$version-darwin-x64/bin"
  set -l target  "$root/default/bin"

  rm -rf $target
  ln -s "$root/versions/$filename" $target
  set -gx PATH "$root/versions/$filename" $PATH

  echo-success "node.global = $version"
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

function node-ls-remote-refresh
  rm $root/cache/versions.json
  node-ls-remote
end

function node-ls-remote
  set -l version "$argv[1]"
  if not test -e $root/cache/versions.json
    curl https://nodejs.org/download/release/index.json 2> /dev/null > $root/cache/versions.json
  else

  end

  cat $root/cache/versions.json | jq -r '.[].version' | grep $version
end

node-setup
# clean_node_version v6.7.0
# node-isntall v6.7.0
# node-isntall v4.7.0
# node-ls
# node-ls-remote

set -gx PATH $HOME/.config/node/default/bin $PATH

# enable global yarn bins
set -gx PATH $HOME/.yarn-config/global/node_modules/.bin $PATH
