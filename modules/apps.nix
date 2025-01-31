{ pkgs, ... }: {

  ##########################################################################
  # 
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  # 
  # TODO Fell free to modify this file to fit your needs.
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    neovim
    git
    cmake

    protobuf
    darwin.iproute2mac

    iterm2
    # GPG related
    gnupg
    pinentry_mac
    # Utilities
    jq
    ffmpeg_6-full
    mkvtoolnix-cli
    age
    flac
  ];
  environment.variables.EDITOR = "nvim";

  # Enable karabiner-elements service
  services."karabiner-elements".enable = true;

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  # 
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas 
    masApps = {
      Xcode = 497799835;
      QQ = 451108668;
    };

    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
      "homebrew/cask-versions"
      "PlayCover/playcover"
      "minio/stable"
    ];

    # `brew install`
    brews = [
      "curl"
      "fnm" # Node.js version management
      "cocoapods"
      "gitui"
      "rclone"
      "bento4"
      "foreman" # for Zed development
      "minio/stable/minio"
      # yubikey
      "ykpers"
      "ykman"
      "filosottile/musl-cross/musl-cross"

      # https://github.com/Automattic/node-canvas/issues/2353
      "pkg-config"
      "cairo"
      "pango"
      "libpng"
      "jpeg"
      "giflib"
      "librsvg"
      "pixman"
      "awscli"
      "opus-tools"
    ];

    # `brew install --cask`
    casks = [
      "google-chrome"

      # Development
      "visual-studio-code"
      "zed"
      "surge" # Network debugging
      "jetbrains-toolbox"
      "flutter"
      "docker"
      "alacritty"
      "navicat-premium-lite"

      # Fonts
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"

      # IM
      "telegram-desktop"
      "discord"

      # Productivity
      "raycast"
      "input-source-pro" # Tool to switch IME, recommended by https://twitter.com/iskyzh/status/1746726405478498560
      "typora"
      "notion"
      "arc"

      # Utilities
      "bruno"      # HTTP client
      "maczip"     # eZip
      "qspace-pro" # File Manager
      "bleunlock"  # Quick unlock
      "squirrel"   # IME
      "010-editor" # Hex Editor
      "msty"       # Chat GUI
      "openvpn-connect"
      "github"
      "obsidian"
      "wireshark"

      # Entertainment
      "iina"
      "playcover-nightly"
      "steam"
      "prismlauncher"
      "obs"

      "lark"
    ];
  };
}
