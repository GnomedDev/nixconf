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

    # General development tools which are going to be needed anyway.
    packages = with pkgs; [ python3 ];

    shell = pkgs.fish;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
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

      programs.ripgrep.enable = true;

      programs.fish.enable = true;
      programs.fish.functions.fish_greeting = "";

      programs.starship.enable = true;
      programs.starship.enableFishIntegration = true;

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "25.11";
    };
}
