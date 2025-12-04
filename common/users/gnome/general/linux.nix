{ pkgs, ... }:
{
  services.tailscale.enable = true;
  users.users.gnome = {
    shell = pkgs.fish;
    # Enable ‘sudo’ for the user.
    extraGroups = [
      "wheel"
      "docker"
    ];
  };
}
