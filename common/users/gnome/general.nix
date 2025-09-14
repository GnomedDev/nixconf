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

    # General development tools which are going to be needed anyway.
    packages = with pkgs; [ python3 ];

    shell = pkgs.fish;
  };

  home-manager.users.gnome =
    { pkgs, ... }:
    {
      # Allow unfree packages like the Android SDK
      xdg.configFile."nixpkgs/config.nix".text = ''
        {...}: {
          allowUnfree = true;
          android_sdk.accept_license = true;
        }
      '';

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

      programs.ripgrep.enable = true;

      programs.fish.enable = true;
      programs.fish.functions.fish_greeting = "";

      programs.starship.enable = true;
      programs.starship.enableFishIntegration = true;

      # Do not change.
      home.stateVersion = "25.11";
    };
}
