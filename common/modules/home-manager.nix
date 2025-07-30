{
  home-manager,
  pkgs,
  ...
}:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gnome = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.

    shell = pkgs.fish;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.gnome =
    { pkgs, ... }:
    {
      programs.fish.enable = true;
      programs.fish.functions.fish_greeting = "";

      programs.starship.enable = true;
      programs.starship.enableFishIntegration = true;

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "25.11";
    };
}
