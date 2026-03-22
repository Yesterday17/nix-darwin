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

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, claude-code, sops-nix }:
  let
    username = "yesterday17";
    hosts = [ "Yesterday17-M3" "Yesterday17-M5" ];

    specialArgs = { inherit self username homebrew-core homebrew-cask claude-code; };

    sharedDarwinModules = [
      nix-homebrew.darwinModules.nix-homebrew

      ./modules/nix-core.nix
      ./modules/host.nix
      ./modules/system.nix
      ./modules/apps.nix
      ./modules/homebrew.nix
    ];

    mkDarwinConfig = hostname: nix-darwin.lib.darwinSystem {
      specialArgs = specialArgs // { inherit hostname; };
      modules = sharedDarwinModules ++ [
        ./hosts/${hostname}.nix
      ];
    };
  in
  {
    darwinConfigurations = builtins.listToAttrs (map (hostname: {
      name = hostname;
      value = mkDarwinConfig hostname;
    }) hosts);

    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      extraSpecialArgs = { inherit claude-code; };
      modules = [
        sops-nix.homeManagerModules.sops
        ./home.nix
        { nixpkgs.config.allowUnfree = true; }
      ];
    };
  };
}
