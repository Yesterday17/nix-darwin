{ config, pkgs, claude-code, ... }:

{
  home.homeDirectory = "/Users/yesterday17";
  home.stateVersion = "25.11";

  home.packages = [ pkgs.claude-code ];
}