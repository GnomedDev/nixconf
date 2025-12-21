{ nix-index-database, machSrc, ... }:
{
  programs.fish.enable = true;

  home-manager.users.gnome = import ../home.nix;
  home-manager.extraSpecialArgs = { inherit machSrc; };
  home-manager.sharedModules = [ nix-index-database.homeModules.nix-index ];
}
