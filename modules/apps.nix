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
    iterm2
    gnupg
    pinentry_mac
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
      # TODO Feel free to add your favorite apps here.

      Xcode = 497799835;
      QQ = 451108668;
    };

    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
      "homebrew/cask-versions"
      "PlayCover/playcover"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      "curl"
      "fnm" # Node.js version management
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      "google-chrome"

      # Development
      "visual-studio-code"
      "zed"
      "surge" # Network debugging

      # Fonts
      "font-jetbrains-mono"

      # IM & audio & remote desktop & meeting
      "telegram-desktop"
      "discord"

      # Productivity
      "raycast"

      # Entertainment
      "iina"
      "playcover-prerelease"
    ];
  };
}
