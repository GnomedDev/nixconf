{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    # Fonts for development
    nerd-fonts.droid-sans-mono
  ];

  home-manager.users.gnome = {
    # Adding packages here instead of users.users.gnome.packages allows for them to be copied to Home Manager Apps on MacOS.
    home.packages =
      with pkgs;
      [
        # LibreOffice
        hunspell
        hyphenDicts.en_US
        hunspellDicts.en_GB-ise

        # Custom packages
        (pkgs.callPackage ../../packages/ffmpeg4discord.nix { })
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        libreoffice-bin
        vlc-bin
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        libreoffice-qt
      ];

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
