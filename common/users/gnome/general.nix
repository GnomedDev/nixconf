{
  home-manager,
  pkgs,
  lib,
  ...
}:

{
  # List services that you want to enable:
  services.tailscale.enable = true;

  # Enable fish system-wide, needed for fish login shells.
  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gnome = {
    home = if pkgs.stdenv.isDarwin then "/Users/gnome" else "/home/gnome";
    shell = pkgs.fish;
  }
  // lib.optionalAttrs pkgs.stdenv.isLinux {
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    isNormalUser = true;
  };

  home-manager.users.gnome = import ./home.nix;
}
