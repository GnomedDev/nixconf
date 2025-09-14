{
  plasma-manager,
  home-manager,
  nixpkgs,
  pkgs,
  lib,
  ...
}:

let
  kdeWallpaperPath = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png";
in
{
  nixpkgs.config.allowUnfree = true;

  # Login screen settings
  services.displayManager.sddm.settings.Users.HideUsers = "gnome";

  # Get rid of plasma packages that we don't need
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    elisa
    kate
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fox = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.

    packages = with pkgs; [
      # LibreOffice
      libreoffice-qt
      hunspell
      hyphenDicts.en_US
      hunspellDicts.en_GB-ize

      # VSCode
      vscode-fhs
    ];
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
        plasma = {
          enable = true;
          overrideConfig = true;

          workspace.colorScheme = "BreezeDark";
          workspace.wallpaper = kdeWallpaperPath;

          # Panel = Taskbar
          panels = [
            {
              floating = false;
            }
          ];
        };

        konsole.enable = true;

        # Others
        firefox.enable = true;
        obsidian.enable = true;
      };

      # Do not change.
      home.stateVersion = "25.11";
    };
}
