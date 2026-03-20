{
  description = "yesterday17's nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, claude-code }:
  let
    username = "yesterday17";
    hostname = "Yesterday17-M5";
    specialArgs = { inherit self username homebrew-core homebrew-cask claude-code; };
  in
  {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      inherit specialArgs;
      modules = [
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager

        ./modules/nix-core.nix
        ./modules/host.nix
        ./modules/system.nix
        ./modules/apps.nix
        ./modules/homebrew.nix
        ./modules/home.nix
      ];
    };

    darwinPackages = self.darwinConfigurations.${hostname}.pkgs;
  };
}
