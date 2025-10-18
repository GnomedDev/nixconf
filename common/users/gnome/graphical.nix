{ pkgs, ... }:
{
  # Enable display brightness control in KDE
  hardware.i2c.enable = true;
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
        panels = [
          {
            height = 46;
            location = "bottom";
            widgets = [
              {
                name = "org.kde.plasma.kickoff";
                config.General.icon = "nix-snowflake-white";
              }
              "org.kde.plasma.pager"
              "org.kde.plasma.icontasks"
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.systemtray"
              "org.kde.plasma.digitalclock"
              "org.kde.plasma.showdesktop"
            ];
          }
        ];

        input = {
          keyboard.layouts = [
            { layout = "gb"; }
          ];
          mice = [
            {
              vendorId = "1532";
              productId = "00c5";
              acceleration = -0.4;
              accelerationProfile = "none";
              name = "Razer DeathAdder V3 HyperSpeed";
            }
          ];
        };
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
