{ pkgs, lib, ... }:
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
        # Random stuff
        utm
        ares
        localsend

        # LibreOffice
        hunspell
        hyphenDicts.en_US
        hunspellDicts.en_GB-ise
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        libreoffice-bin
        ghostty-bin
        vlc-bin
        (callPackage ../../packages/hot.nix { })
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        libreoffice-qt
      ];

    xdg.configFile.ghostty-config = {
      target = "ghostty/config";
      enable = pkgs.stdenv.isDarwin;
      source = (pkgs.formats.toml { }).generate "ghostty-config.toml" {
        command = lib.getExe pkgs.fish;
        shell-integration = "fish";

        macos-titlebar-style = "tabs";
        window-show-tab-bar = "always";

        theme = "Apple System Colors";
      };
    };

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
