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
      programs.git = {
        enable = true;
        userName = "GnomedDev";
        userEmail = "daisy2005thomas@gmail.com";

        signing = {
          signByDefault = true;

          format = "ssh";
          key = "/home/gnome/.ssh/id_rsa";
        };

        extraConfig.push.autoSetupRemote = "true";
      };

      programs.fish.enable = true;
      programs.fish.functions.fish_greeting = "";

      programs.starship.enable = true;
      programs.starship.enableFishIntegration = true;

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "25.11";
    };
}
