{ pkgs, ... }:

{
  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];

    # substituers that will be considered before the official ones(https://cache.nixos.org)
    substituters = [
      #"https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      "https://cache.lix.systems"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    ];
    builders-use-substitutes = true;
  };

  # Auto upgrade nix package and the daemon service.
  nix.enable = true;
  nix.package = pkgs.nix;
}
