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
  nixpkgs.overlays = [
    (final: prev: {
      kdePackages = prev.kdePackages.overrideScope (
        kdeFinal: kdePrev: {
          plasma-desktop = prev.buildEnv {
            name = "plasma-desktop-with-sddm-theme";
            paths = [
              kdePrev.plasma-desktop
              (prev.runCommandNoCC "sddm-theme" { } ''
                mkdir -p $out/share/sddm/themes/breeze/
                echo '[General]
                background=${kdeWallpaperPath}' > $out/share/sddm/themes/breeze/theme.conf.user
              '')
            ];
          };
        }
      );
    })
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

      # Krita
      krita

      # Tor Browser
      tor-browser
    ];
  };

  home-manager.users.fox =
    { pkgs, ... }:
    {
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
              height = 50;
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
