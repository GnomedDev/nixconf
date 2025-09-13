{
  plasma-manager,
  home-manager,
  pkgs,
  ...
}:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fox = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.fox =
    { pkgs, ... }:
    {
      # Allow unfree packages like the Android SDK
      xdg.configFile."nixpkgs/config.nix".text = ''
        {...}: {
          allowUnfree = true;
          android_sdk.accept_license = true;
        }
      '';

      programs = {
        # KDE apps
        plasma.enable = true;
        konsole.enable = true;

        # Others
        firefox.enable = true;
        obsidian.enable = true;
      };

      # Do not change.
      home.stateVersion = "25.11";
    };
}
