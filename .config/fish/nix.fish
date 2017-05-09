#! /usr/local/bin/fish

if test  -n "$HOME" ;
    set -xg NIX_LINK "$HOME/.nix-profile"

    # Set the default profile.
    if not test -L "$NIX_LINK" ;
        echo "creating $NIX_LINK" >&2
        set -l _NIX_DEF_LINK /nix/var/nix/profiles/default
        /nix/store/cdybb3hbbxf6k84c165075y7vkv24vm2-coreutils-8.23/bin/ln -s "$_NIX_DEF_LINK" "$NIX_LINK"
    end

    set -xg PATH $NIX_LINK/bin $NIX_LINK/sbin $PATH

    # Subscribe the user to the Nixpkgs channel by default.
    if not test -e $HOME/.nix-channels ;
        echo "https://nixos.org/channels/nixpkgs-unstable nixpkgs" > $HOME/.nix-channels
    end

    # Append ~/.nix-defexpr/channels/nixpkgs to $NIX_PATH so that
    # <nixpkgs> paths work when the user has fetched the Nixpkgs
    # channel.
    # set -xg  NIX_PATH ${NIX_PATH:+$NIX_PATH:}nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs
    set -xg  NIX_PATH $NIX_PATH $HOME/.nix-defexpr/channels/nixpkgs

    # Set $SSL_CERT_FILE so that Nixpkgs applications like curl work.
    if test  -e /etc/ssl/certs/ca-bundle.crt ;  # Fedora, NixOS
        set -xg SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt ;
    else if test -e /etc/ssl/certs/ca-certificates.crt ;  # Ubuntu, Debian
        set -xg SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
    else if test -e "$NIX_LINK/etc/ca-bundle.crt" ;  # fall back to Nix profile
        set -xg SSL_CERT_FILE "$NIX_LINK/etc/ca-bundle.crt"
    end
end
# sh /Users/spenner/.nix-profile/etc/profile.d/nix.sh
