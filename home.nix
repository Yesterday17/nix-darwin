{ config, lib, pkgs, claude-code, ... }:

{
  home.homeDirectory = "/Users/yesterday17";
  home.stateVersion = "25.11";

  home.packages = [ pkgs.claude-code ];

  # Berkeley Mono font from iCloud Drive
  home.activation.installBerkeleyMono = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    FONT_SRC="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Fonts"
    FONT_DST="$HOME/Library/Fonts"
    mkdir -p "$FONT_DST"
    cp -f "$FONT_SRC/BerkeleyMono-Regular.otf" "$FONT_DST/"
    cp -f "$FONT_SRC/BerkeleyMonoVariable 2.002 calt.ttf" "$FONT_DST/"
  '';
  home.shellAliases.lcc = "claude";

  # Git
  programs.git = {
    enable = true;
    settings = {
      user.name = "Yesterday17";
      user.email = "mmf@mmf.moe";
      user.signingkey = "3CB3DFA9524C0B90";
      commit.gpgsign = true;
      tag.gpgsign = true;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rerere.enabled = true;
    };
  };

  # Zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 50000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
    };
  };

  # Direnv - auto-load .envrc
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # VS Code
  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = {
        "editor.fontFamily" = "'Berkeley Mono', 'JetBrains Mono', monospace";
        "editor.fontSize" = 14;
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "'Berkeley Mono', 'JetBrains Mono', monospace";
      };
    };
  };

  # Ghostty (installed via homebrew, config managed here)
  programs.ghostty = {
    enable = true;
    package = null;
    enableZshIntegration = true;
    settings = {
      font-family = "Berkeley Mono";
      font-size = 14;
      theme = "dark:Gruvbox Dark,light:Gruvbox Light";
      window-decoration = false;
      macos-option-as-alt = true;
    };
  };

  # Stats - menu bar system monitor
  targets.darwin.defaults."eu.exelban.Stats" = {
    "RunAtLogin" = true;
    "CPU_widget" = "mini";
    "RAM_widget" = "mini";
    "Disk_widget" = "mini";
    "Net_widget" = "mini";
    "Battery_widget" = "mini";
    "Sensors_widget" = "mini";
    "GPU_widget" = "";
    "Bluetooth_widget" = "";
  };

  # Input Source Pro
  targets.darwin.defaults."com.runjuu.Input-Source-Pro" = {
    isLaunchAtLogin = true;
    isShowIconInMenuBar = false;
    systemWideDefaultKeyboardId = "com.apple.keylayout.ABC";
    browserAddressDefaultKeyboardId = "com.apple.keylayout.ABC";
    isActiveWhenSwitchApp = true;
    isActiveWhenSwitchInputSource = false;
    isCJKVFixEnabled = false;
    isDetectSpotlightLikeApp = true;
    isRestorePreviouslyUsedInputSource = true;
    isEnableURLSwitchForChrome = true;
    isEnableURLSwitchForSafari = true;
  };
  home.activation.inputSourceProData = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    DOMAIN="com.runjuu.Input-Source-Pro"
    defaults write "$DOMAIN" appearanceMode -data "IkRhcmsi"
    defaults write "$DOMAIN" indicatorInfo -data "eyJiYXNlIjoiaWNvbkFuZFRpdGxlIn0="
    defaults write "$DOMAIN" indicatorPosition -data "eyJiYXNlIjoibmVhck1vdXNlIn0="
    defaults write "$DOMAIN" indicatorSize -data "eyJiYXNlIjoyfQ=="
    defaults write "$DOMAIN" indicatorBackground -data "eyJsaWdodCI6IjBjNzQ4OWZmIiwiZGFyayI6IjAwMDAwMGZmIn0="
    defaults write "$DOMAIN" indicatorForgeground -data "eyJkYXJrIjoiZmZmZmZmZmYiLCJsaWdodCI6ImZmZmZmZmZmIn0="
  '';

  # GPG agent with SSH support (YubiKey)
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = builtins.fetchurl {
          url = "https://github.com/Yesterday17.gpg";
          sha256 = "0z4pnpwjag0jq32fazk402dn7q7468pgawmpxl8y2b991fz3m3sc";
        };
        trust = 5;
      }
    ];
  };
  home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    enable-ssh-support
    default-cache-ttl 600
    max-cache-ttl 7200
  '';
  # YubiKey authentication subkey keygrip
  home.file.".gnupg/sshcontrol".text = ''
    58B1D9D210192CB7CF3E012C99AE0D41A867E1FD
  '';

  # Use GPG agent as SSH agent
  programs.zsh.initContent = ''
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK="$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)"
    ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
  '';
}
