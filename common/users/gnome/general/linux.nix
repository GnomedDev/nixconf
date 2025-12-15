{ pkgs, ... }:
{
  services.tailscale.enable = true;
  users.users.gnome = {
    shell = pkgs.fish;
    isNormalUser = true;
    home = "/home/gnome";

    # Enable ‘sudo’ for the user.
    extraGroups = [
      "i2c"
      "wheel"
      "docker"
    ];
  };
}
