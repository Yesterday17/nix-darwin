{ config, pkgs, claude-code, ... }:

{
  home.homeDirectory = "/Users/yesterday17";
  home.stateVersion = "25.11";

  home.packages = [ pkgs.claude-code ];
  home.shellAliases.lcc = "claude";

  # Git
  programs.git = {
    enable = true;
    settings = {
      user.name = "Yesterday17";
      user.email = "mmf@mmf.moe";
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

  # GPG
  programs.gpg.enable = true;
  home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
  '';
}
