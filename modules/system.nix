{ username, ... }:

{
  system = {
    primaryUser = username;

    activationScripts.activateSettings.text = ''
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      menuExtraClock.Show24Hour = true;

      dock = {
        orientation = "right";
        autohide = true;
        show-recents = false;

        persistent-apps = [
          "/Applications/Google Chrome.app"
          "/Applications/Telegram Desktop.app"
          "/Applications/Discord.app"
          "/Applications/LarkSuite.app"
          "/Applications/QQ.app"
          { spacer = { small = true; }; }
          "/Applications/Visual Studio Code.app"
          "/Applications/Zed Preview.app"
          "/Applications/cmux.app"
          "/Applications/Surge.app"
          { spacer = { small = true; }; }
          "/System/Applications/System Settings.app"
        ];
      };

      finder = {
        AppleShowAllExtensions = true;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
      };

      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = false;
        "ApplePressAndHoldEnabled" = false;
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  programs.zsh.enable = true;
  users.users.${username}.home = "/Users/${username}";
}
