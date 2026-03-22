{ config, lib, pkgs, claude-code, rime-wanxiang, ... }:

let
  rime-wanxiang-flypy = pkgs.stdenvNoCC.mkDerivation {
    pname = "rime-wanxiang-flypy";
    version = rime-wanxiang.rev or "unstable";
    src = rime-wanxiang;
    nativeBuildInputs = with pkgs; [ python3 rsync zip unzip ];
    buildPhase = ''
      export HOME=$TMPDIR
      export SCHEMA_NAME=flypy
      bash .github/workflows/scripts/release-build.sh
    '';
    installPhase = ''
      mkdir -p $out
      unzip -o dist/rime-wanxiang-flypy-fuzhu.zip -d $out
    '';
  };
  rime-gram = pkgs.fetchurl {
    url = "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram";
    hash = "sha256-Ll7zRgRn6u0+Vpo2BQwhMTnjTHropbvVXKsyeg2A0Bc=";
  };
in
{
  home.username = "yesterday17";
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

  # Rime (Squirrel) - wanxiang schema + custom config
  home.activation.installRime = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    RIME_DIR="$HOME/Library/Rime"
    mkdir -p "$RIME_DIR"

    # Copy wanxiang flypy release files
    chmod -R u+w "$RIME_DIR" 2>/dev/null || true
    cp -rf ${rime-wanxiang-flypy}/* "$RIME_DIR/"
    chmod -R u+w "$RIME_DIR"

    # Install gram model
    cp -f ${rime-gram} "$RIME_DIR/wanxiang-lts-zh-hans.gram"

    # Overlay custom config (takes precedence)
    cp -rf ${./rime}/* "$RIME_DIR/"
  '';

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

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
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
      extensions = with pkgs.vscode-extensions; [
        golang.go
        wakatime.vscode-wakatime
        bradlc.vscode-tailwindcss
        github.copilot-chat
        jnoortheen.nix-ide
        vscodevim.vim
      ] ++ [
        (pkgs.vscode-utils.extensionFromVscodeMarketplace {
          name = "oxc-vscode";
          publisher = "oxc";
          version = "1.50.0";
          hash = "sha256-ZEL3nwq2nY776ZS6V+0r3+IAwH21vzwWpYM3zLj05sI=";
        })
        (pkgs.vscode-utils.extensionFromVscodeMarketplace {
          name = "native-preview";
          publisher = "TypeScriptTeam";
          version = "0.20260321.1";
          hash = "sha256-pk7jrHATHyvoN4kEKmAompAGJZ/Gmddn//1yPrj6jYI=";
        })
        (pkgs.vscode-utils.extensionFromVscodeMarketplace {
          name = "claude-code";
          publisher = "anthropic";
          version = "2.1.81";
          hash = "sha256-AblL1ChlZ8JKMhKVz/AAV22iyGfWQWXfLY2ntLWg/ik=";
        })
      ];
      userSettings = {
        "editor.fontFamily" = "'Berkeley Mono', 'JetBrains Mono', monospace";
        "editor.fontSize" = 14;
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "'Berkeley Mono', 'JetBrains Mono', monospace";
        "workbench.secondarySideBar.defaultVisibility" = "hidden";
        "window.autoDetectColorScheme" = true;
        "gopls" = {
          "formatting.gofumpt" = true;
        };
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
      term = "xterm-256color";
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
    /usr/bin/defaults write "$DOMAIN" appearanceMode -data "224461726b22"
    /usr/bin/defaults write "$DOMAIN" indicatorInfo -data "7b2262617365223a2269636f6e416e645469746c65227d"
    /usr/bin/defaults write "$DOMAIN" indicatorPosition -data "7b2262617365223a226e6561724d6f757365227d"
    /usr/bin/defaults write "$DOMAIN" indicatorSize -data "7b2262617365223a327d"
    /usr/bin/defaults write "$DOMAIN" indicatorBackground -data "7b226c69676874223a223063373438396666222c226461726b223a223030303030306666227d"
    /usr/bin/defaults write "$DOMAIN" indicatorForgeground -data "7b226461726b223a226666666666666666222c226c69676874223a226666666666666666227d"
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
  # Sops secrets
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    secrets.wakatime_api_key = {};
  };

  sops.templates.".wakatime.cfg" = {
    path = "${config.home.homeDirectory}/.wakatime.cfg";
    content = ''
      [settings]
      api_key = ${config.sops.placeholder.wakatime_api_key}
    '';
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

    # fnm (Node.js version manager)
    eval "$(${pkgs.fnm}/bin/fnm env --use-on-cd --shell zsh)"
  '';
}
