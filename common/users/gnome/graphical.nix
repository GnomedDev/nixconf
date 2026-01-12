{ pkgs, lib, ... }:
let
  prettierFormatter = {
    external = {
      command = lib.getExe pkgs.prettier;
      arguments = [
        "--stdin-filepath"
        "{buffer_path}"
      ];
    };
  };
in
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
        utm
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
        extraPackages = with pkgs; [
          nixd
          nixfmt
        ];

        # I want to manage as much configuration via Nix as possible
        mutableUserSettings = false;
        mutableUserKeymaps = false;
        mutableUserTasks = false;
        mutableUserDebug = false;

        userSettings = {
          # I do not like creating slopware.
          disable_ai = true;
          # Setting a terminal globally is a complete pain.
          terminal.shell.program = lib.getExe pkgs.fish;
          # Show diagnostics inline, a'la VSCode Error Lens
          diagnostics.inline.enabled = true;
          # Sensible tab width
          tab_size = 4;

          # Language specific configuration
          languages = {
            CSS.formatter = prettierFormatter;
            Markdown.formatter = prettierFormatter;
            Python.formatter.external = {
              command = "poetry";
              arguments = [
                "run"
                "black"
                "--stdin-filename"
                "{buffer_path}"
                "-"
              ];
            };
            Nix = {
              tab_size = 2;
              formatter.external.command = lib.getExe pkgs.nixfmt;
              language_servers = [
                "nixd"
                "!nil"
              ];
            };
          };

          file_types.XML = [ "kml" ];

          # Coming from VSCode
          theme = "VSCode Dark Modern";
        };

        extensions = [
          "xml"
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
