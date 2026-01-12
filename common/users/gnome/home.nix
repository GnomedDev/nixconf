{ pkgs, machSrc, ... }:
let
  homeDirectory = if pkgs.stdenv.isDarwin then "/Users/gnome" else "/home/gnome";
  sshKey = "${homeDirectory}/.ssh/id_rsa";
in
{
  programs.git = {
    enable = true;
    settings = {
      push.autoSetupRemote = "true";
      core.excludesfile = "${pkgs.writeText "global-gitignore" ''
        .direnv
        .envrc
      ''}";
      user = {
        name = "GnomedDev";
        email = "daisy2005thomas@gmail.com";
      };
      Host."github.com" = {
        User = "git";
        IdentityFile = sshKey;
      };
    };

    signing = {
      signByDefault = true;

      format = "ssh";
      key = sshKey;
    };
  };

  programs.ripgrep.enable = true;

  programs.fish.enable = true;
  programs.fish.functions.fish_greeting = "";

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      package.disabled = true;
      git_status.stashed = "";
      git_branch.truncation_length = 20;
      nix_shell.format = "with [$symbol]($style)[Nix Dev Shell]($style) ";
    };
  };

  programs.nix-index-database.comma.enable = true;

  programs.home-manager.enable = true;

  home = {
    username = "gnome";
    inherit homeDirectory;
    packages = with pkgs; [
      # Custom packages
      (callPackage ../../packages/ffmpeg4discord.nix { })
      (callPackage ../../packages/mach.nix { inherit machSrc; })

      # General stuff I just want avaliable
      python3
    ];

    # Do not change.
    stateVersion = "25.11";
  };
}
