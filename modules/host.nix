{ self, claude-code, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 4;

  ids.gids.nixbld = 350;

  nixpkgs.overlays = [
    claude-code.overlays.default
    (final: prev: {
      karabiner-elements = prev.karabiner-elements.overrideAttrs (old: {
        version = "14.13.0";
        src = prev.fetchurl {
          inherit (old.src) url;
          hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
        };
      });
    })
  ];
}
