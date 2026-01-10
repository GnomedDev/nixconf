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

      zed-editor = {
        enable = true;
        userSettings = {
          # I do not like creating slopware.
          disable_ai = true;
          # Setting a terminal globally is a complete pain.
          terminal.shell.program = lib.getExe pkgs.fish;
          # Automatically fetch dependencies of Nix projects.
          lsp.nil.settings.nil.nix.autoArchive = true;
          # Set prettier as a third party formatter for all files, since it supports a lot.
          formatter = [
            "language_server"
            {
              external = {
                command = lib.getExe pkgs.prettier;
                arguments = [
                  "--stdin-filepath"
                  "{buffer_path}"
                ];
              };
            }
          ];

          # Language specific configuration
          languages.Nix.formatter.external.command = "nixfmt";

          # Coming from VSCode
          theme = "VSCode Dark Modern";
        };
        userKeymaps = [
          { bindings.f1 = "command_palette::Toggle"; }
        ];
        extensions = [
          "nix"
          "toml"
          "dependi"
          "github-actions"
          "vscode-dark-modern"
        ];
      };

      # Others
      firefox.enable = true;
      obsidian.enable = true;
    };
  };
}
