{ pkgs, lib, ... }:
let
  homeDirectory = if pkgs.stdenv.isDarwin then "/Users/gnome" else "/home/gnome";
in
{
  programs.git = {
    enable = true;
    settings = {
      push.autoSetupRemote = "true";
      user = {
        name = "GnomedDev";
        email = "daisy2005thomas@gmail.com";
      };
    };

    signing = {
      signByDefault = true;

      format = "ssh";
      key = "${homeDirectory}/.ssh/id_rsa";
    };
  };

  programs.ripgrep.enable = true;

  programs.fish.enable = true;
  programs.fish.functions.fish_greeting = "";

  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;

  programs.nix-index-database.comma.enable = true;

  programs.home-manager.enable = true;

  home = {
    username = "gnome";
    inherit homeDirectory;
    packages = with pkgs; [
      python3
      nixfmt
      nil
    ];

    # Do not change.
    stateVersion = "25.11";
  };
}
