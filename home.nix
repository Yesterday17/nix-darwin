{ config, pkgs, claude-code, ... }:

{
  home.homeDirectory = "/Users/yesterday17";
  home.stateVersion = "25.11";

  nixpkgs.overlays = [ claude-code.overlays.default ];
  home.packages = [ pkgs.claude-code ];
}