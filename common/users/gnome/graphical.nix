{ pkgs, ... }:
{
  # Login screen settings
  services.displayManager.sddm.settings.Users.HideUsers = "gnome";
  nixpkgs.overlays = [
    (final: prev: {
      kdePackages = prev.kdePackages.overrideScope (
        kdeFinal: kdePrev: {
          powerdevil = kdePrev.powerdevil.overrideAttrs (
            finalAttrs: prevAttrs: {
              buildInputs = prevAttrs.buildInputs ++ [ prev.ddcutil ];
              cmakeFlags = [ "-DHAVE_DDCUTIL=On" ];
            }
          );
        }
      );
    })
  ];

  home-manager.users.gnome = {
    programs = {
      # KDE apps
      konsole.enable = true;
      plasma = {
        enable = true;
        overrideConfig = true;

        workspace.colorScheme = "BreezeDark";

        # Panel = Taskbar
        panels = [ { height = 46; } ];
      };

      # Vesktop (Discord)
      vesktop = {
        enable = true;
        settings = {
          discordBranch = "stable";
          minimizeToTray = true;
          arRPC = false;
        };
      };

      # VSCode
      vscode = {
        enable = true;
        package = pkgs.vscode;

        # Sync extensions via settings sync.
        mutableExtensionsDir = true;
      };

      # Others
      firefox.enable = true;
      obsidian.enable = true;
    };
  };
}
