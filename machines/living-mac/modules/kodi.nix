{ pkgs, ... }:

let
  kodiPkg = pkgs.kodi-gbm;
  sleepyIp = "192.168.1.71";
in
{
  # Enable the ALSA for Kodi Audio.
  hardware.alsa.enable = true;

  # Disable the internal display.
  boot.kernelParams = [
    "video=eDP-1:d"
    "video=HDMI-A-1:3840x2160@60"
  ];

  # Enable graphical drivers.
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      intel-ocl
    ];
  };

  # Allow any user to power off or reboot the machine.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.login1.power-off" ||
          action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
          action.id == "org.freedesktop.login1.reboot" ||
          action.id == "org.freedesktop.login1.reboot-multiple-sessions")
      {
          return polkit.Result.YES;
      }
    });
  '';

  # Create a user to sandbox Kodi, so it doesn't interfere or rely on user-specific config.
  users.users.kodi = {
    enable = true;
    isNormalUser = true;
  };

  # Enable the Kodi package for the kodi user specifically.
  home-manager.users.kodi =
    { pkgs, ... }:
    {
      programs.kodi = {
        enable = true;
        package = kodiPkg;
        settings.filecache.buffermode = "5"; # Buffer all content, including local FS
        sources.video.source = [
          {
            name = "External HDD";
            path = "/mnt/ext-hdd/Media";
            allowsharing = "true";
          }
          {
            name = "Movies";
            path = "ftp://${sleepyIp}:21/Movies";
            allowsharing = "true";
          }
          {
            name = "TV Shows";
            path = "ftp://${sleepyIp}:21/TV Shows";
            allowsharing = "true";
          }
        ];
      };

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
