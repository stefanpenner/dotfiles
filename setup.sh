// setup
add-apt-repository ppa:neovim-ppa/unstable
apt-get update
apt-get install fish python-software-properties neovim jq htop
mkdir -p src/stefanpenner
cd src/stefanpenner
git clone https://github.com/stefanpenner/dotfiles
.dotfiles/sync.sh
cd ~

nvim +PlugInstall
