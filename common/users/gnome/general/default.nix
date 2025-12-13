{ nix-index-database, ... }:
{
  programs.fish.enable = true;

  home-manager.users.gnome = import ../home.nix;
  home-manager.sharedModules = [ nix-index-database.homeModules.nix-index ];
}
