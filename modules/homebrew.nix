{ username, homebrew-core, homebrew-cask, config, ... }:

{
  nix-homebrew = {
    enable = true;
    enableRosetta = false;
    user = username;
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
    mutableTaps = false;
  };

  # Align homebrew taps config with nix-homebrew
  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };

    masApps = {
      Xcode = 497799835;
      QQ = 451108668;
    };

    brews = [
      "curl"
      "fnm"
      "cocoapods"
      "rclone"
      "bento4"
      "ykpers"
      "ykman"
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

    casks = [
      # Browsers
      "google-chrome"

      # Development
      "zed@preview"
      "cmux"
      "surge"

      # Fonts
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"

      # IM
      "telegram-desktop"
      "discord"
      "lark"

      # Productivity
      "input-source-pro"

      # Terminal
      "ghostty"

      # System monitor
      "stats"

      # Utilities
      "squirrel-app"
      "010-editor"
      "tunnelblick"
      "typeless"

      # Entertainment
      "iina"
      "steam"
      "prismlauncher"
      "obs"
    ];
  };
}
