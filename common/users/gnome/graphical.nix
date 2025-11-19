{ pkgs, ... }:
{
  # Graphical systems have enough processing power to run dockerd in the background, even if not strictly necessary.
  virtualisation.docker.enable = true;

  users.users.gnome.packages = with pkgs; [
    # LibreOffice
    (if pkgs.stdenv.isDarwin then libreoffice-bin else libreoffice-qt)
    hunspell
    hyphenDicts.en_US
    hunspellDicts.en_GB-ise

    # Custom packages
    (pkgs.callPackage ../../packages/ffmpeg4discord.nix { })
  ];

  home-manager.users.gnome = {
    programs = {
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
