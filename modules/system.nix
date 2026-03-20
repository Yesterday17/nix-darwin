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
          "/Users/yesterday17/Applications/Home Manager Apps/Visual Studio Code.app"
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

      # Spotlight - only useful categories
      CustomUserPreferences."com.apple.Spotlight" = {
        orderedItems = [
          { enabled = true;  name = "APPLICATIONS"; }
          { enabled = true;  name = "MENU_EXPRESSION"; }       # Calculator
          { enabled = true;  name = "MENU_CONVERSION"; }       # Unit conversion
          { enabled = true;  name = "MENU_DEFINITION"; }       # Dictionary
          { enabled = true;  name = "SYSTEM_PREFS"; }          # System Settings
          { enabled = false; name = "DOCUMENTS"; }
          { enabled = false; name = "DIRECTORIES"; }
          { enabled = false; name = "PRESENTATIONS"; }
          { enabled = false; name = "SPREADSHEETS"; }
          { enabled = false; name = "PDF_DOCUMENTS"; }
          { enabled = false; name = "MESSAGES"; }
          { enabled = false; name = "CONTACT"; }
          { enabled = false; name = "EVENT_TODO"; }
          { enabled = false; name = "IMAGES"; }
          { enabled = false; name = "BOOKMARKS"; }
          { enabled = false; name = "MUSIC"; }
          { enabled = false; name = "MOVIES"; }
          { enabled = false; name = "FONTS"; }
          { enabled = false; name = "MENU_OTHER"; }
          { enabled = false; name = "MENU_WEBSEARCH"; }
          { enabled = false; name = "MENU_SPOTLIGHT_SUGGESTIONS"; }
        ];
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
