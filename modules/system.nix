{ pkgs, ... }:

  ###################################################################################
  #
  #  macOS's System configuration
  #
  #  All the configuration options are documented here:
  #    https://daiderd.com/nix-darwin/manual/index.html#sec-options
  #
  ###################################################################################
{

  system = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      menuExtraClock.Show24Hour = true;  # show 24 hour clock

      dock = {
        orientation = "right";
        autohide = true;
        show-recents = false;
      };

      finder = {
        AppleShowAllExtensions = true;           # Show all file extensions
	FXDefaultSearchScope = "SCcf";           # Search in current folder by default
        FXEnableExtensionChangeWarning = false;  # Do not show warning when changing file extension
	FXPreferredViewStyle = "Nlsv";           # Use list view as default finder view
        QuitMenuItem = true;                     # Allow quitting finder
        ShowPathbar = true;                      # Show path breadcrumbs in finder windows
        ShowStatusBar = true;                    # Show status bar
        _FXShowPosixPathInTitle = true;          # Show full POSIX path in window title
      };

      NSGlobalDomain = {
        # Disable natural scrolling
        "com.apple.swipescrolldirection" = false;
      };
    };

  };

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;

}
