# TODO:
#  * switch for OSX
#  * add CI


/bin/bash -c "$(curl -sL https://git.io/vokNn)" && \
apt-fast update && \
apt-fast -qq install software-properties-common python-software-properties && \
add-apt-repository ppa:neovim-ppa/unstable && \
add-apt-repository ppa:saiarcot895/myppa && \
apt-fast update && \
apt-fast -qq install fish python-software-properties neovim jq htop git curl wget thefuck tmux  build-essential && \
mkdir -p $HOME/src/stefanpenner && \
git clone https://github.com/stefanpenner/dotfiles $HOME/src/stefanpenner/dotfiles && \
$HOME/src/stefanpenner/dotfiles/sync.sh && \
nvim +PlugInstall +qall! && \

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
curl -sSL https://get.rvm.io | bash -s stable --ruby=latest


