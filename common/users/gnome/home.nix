{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "GnomedDev";
    userEmail = "daisy2005thomas@gmail.com";

    signing = {
      signByDefault = true;

      format = "ssh";
      key = "/home/gnome/.ssh/id_rsa";
    };

    extraConfig.push.autoSetupRemote = "true";
  };

  programs.ripgrep.enable = true;

  programs.fish.enable = true;
  programs.fish.functions.fish_greeting = "";

  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;

  programs.home-manager.enable = true;

  home = {
    username = "gnome";
    homeDirectory = "/home/gnome";
    packages = with pkgs; [
      python3
      nixfmt
    ];

    # Do not change.
    stateVersion = "25.11";
  };
}
