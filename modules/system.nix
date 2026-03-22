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

      # Lock screen after 5 minutes idle
      CustomUserPreferences."com.apple.screensaver" = {
        idleTime = 300;
      };

      # Screenshot: Cmd+Shift+S for area to clipboard
      CustomUserPreferences."com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # Disable default Cmd+Shift+S (28: area to clipboard is Cmd+Ctrl+Shift+4 by default)
          "28" = {
            enabled = true;
            value = {
              parameters = [ 115 1 1179648 ]; # 's', keycode 1, Cmd+Shift
              type = "standard";
            };
          };
        };
      };

      # Global preferences not in nix-darwin typed options
      CustomUserPreferences."NSGlobalDomain" = {
        TISRomanSwitchState = 1; # Use Caps Lock to switch to and from ABC
        NSUserQuotesArray = [ ''"'' ''"'' "'" "'" ]; # Straight quotes
      };

      # Kotoeri (Japanese IME)
      CustomUserPreferences."com.apple.inputmethod.Kotoeri" = {
        JIMPrefConvertWithPunctuationKey = 0;  # Don't auto-convert on punctuation
        JIMPrefShiftKeyActionKey = 1;          # Shift toggles between modes
        JIMPrefWindowsModeKey = 0;             # Mac-style behavior
      };

      # Input sources: Squirrel (Rime)
      CustomUserPreferences."com.apple.inputsources" = {
        AppleEnabledThirdPartyInputSources = [
          {
            "Bundle ID" = "im.rime.inputmethod.Squirrel";
            "Input Mode" = "im.rime.inputmethod.Squirrel.Hans";
            InputSourceKind = "Input Mode";
          }
          {
            "Bundle ID" = "im.rime.inputmethod.Squirrel";
            InputSourceKind = "Keyboard Input Method";
          }
        ];
      };

      # Input sources: ABC + Japanese (Romaji)
      CustomUserPreferences."com.apple.HIToolbox" = {
        AppleEnabledInputSources = [
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 252;
            "KeyboardLayout Name" = "ABC";
          }
          {
            "Bundle ID" = "com.apple.inputmethod.Kotoeri.RomajiTyping";
            "Input Mode" = "com.apple.inputmethod.Japanese";
            InputSourceKind = "Input Mode";
          }
          {
            "Bundle ID" = "com.apple.inputmethod.Kotoeri.RomajiTyping";
            InputSourceKind = "Keyboard Input Method";
          }
          {
            "Bundle ID" = "com.apple.CharacterPaletteIM";
            InputSourceKind = "Non Keyboard Input Method";
          }
          {
            "Bundle ID" = "com.apple.50onPaletteIM";
            InputSourceKind = "Non Keyboard Input Method";
          }
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
