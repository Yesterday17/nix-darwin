{ username, claude-code, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../home.nix;
    extraSpecialArgs = { inherit claude-code; };
  };
}
