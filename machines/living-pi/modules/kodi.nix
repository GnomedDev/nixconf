{ pkgs, ... }:

let
  kodiPkg = pkgs.kodi-gbm;
in
{
  nixpkgs.config.allowUnfree = true;

  # Enable the ALSA for Kodi Audio.
  hardware.alsa.enable = true;

  # Enable graphical drivers, using Intel for now.
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      intel-ocl
    ];
  };

  # Create a user to sandbox Kodi, so it doesn't interfere or rely on user-specific config.
  users.users.kodi = {
    enable = true;
    isNormalUser = true;
  };

  # Enable the Kodi package for the kodi user specifically.
  home-manager.users.kodi =
    { pkgs, ... }:
    {
      programs.kodi.enable = true;
      programs.kodi.package = kodiPkg;

      home.stateVersion = "25.11";
    };

  # Configure systemd to start kodi
  systemd.services.kodi = {
    enable = true;
    after = [ "sound.target" ];
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      # Run as the Kodi User
      User = "kodi";
      Type = "simple";
      ExecStart = "${kodiPkg}/bin/kodi-standalone";
      # Run with raw video/input/audio permissions
      SupplementaryGroups = [
        "video"
        "input"
        "audio"
      ];
      # Restart if crashed/stopped
      Restart = "always";
      # Wait for 15s before force killing if asked to stop
      TimeoutStopSec = "15s";
      TimeoutStopFailureMode = "kill";
    };
  };
}
