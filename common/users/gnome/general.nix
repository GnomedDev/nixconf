{
  home-manager,
  pkgs,
  ...
}:

{
  # List services that you want to enable:
  services.tailscale.enable = true;

  # Enable fish system-wide, needed for fish login shells.
  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gnome = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.

    shell = pkgs.fish;
  };

  home-manager.users.gnome = import ./home.nix;
}
