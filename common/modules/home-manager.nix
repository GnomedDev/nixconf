{
  home-manager,
  ...
}:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gnome = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
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

        extraConfig.push.autoSetupRemote = "true";
      };

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "25.11";
    };
}
