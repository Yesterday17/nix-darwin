{ username, claude-code, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../home.nix;
    backupFileExtension = "bak";
    extraSpecialArgs = { inherit claude-code; };
  };
}
