{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    home-manager
    vim
    neovim
    git
    cmake

    protobuf
    iproute2mac

    # GPG
    gnupg
    pinentry_mac

    # Utilities
    jq
    ffmpeg-full
    mkvtoolnix-cli
    flac

    # Shell
    nushell
    zellij

    # VPN
    tailscale

    # Go
    go
    gopls
    delve
    golangci-lint
    gofumpt

    # Node.js
    fnm

    # Nix
    direnv

    # Load testing
    k6

    # Chatting
    mumble
  ];

  environment.variables.EDITOR = "nvim";

  services.karabiner-elements.enable = true;
  services.tailscale.enable = true;
}
