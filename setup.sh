# TODO:
#  * switch for OSX
#  * add CI
apt-get update && \
apt-get -qq install software-properties-common python-software-properties && \
add-apt-repository ppa:neovim-ppa/unstable && \
apt-get update && \
apt-get -qq install fish python-software-properties neovim jq htop git curl wget thefuck tmux  build-essential && \
mkdir -p $HOME/src/stefanpenner && \
git clone https://github.com/stefanpenner/dotfiles $HOME/src/stefanpenner/dotfiles && \
$HOME/src/stefanpenner/dotfiles/sync.sh && \
nvim +PlugInstall +qall! && \

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
curl -sSL https://get.rvm.io | bash -s stable --ruby=latest


