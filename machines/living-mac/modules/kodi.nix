{ pkgs, ... }:

let
  kodiPkg = pkgs.kodi-wayland;
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
    extraGroups = [ "audio" ];
  };

  # Enable the Kodi package for the kodi user specifically.
  home-manager.users.kodi =
    { ... }:
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

      xdg.configFile."kanshi/config".text = ''
        profile tv {
          output "*" mode 3840x2160@60
        }
      '';

      home.stateVersion = "25.11";
    };

  # Configure Cage to wrap Kodi via Systemd.
  services.cage = {
    enable = true;
    user = "kodi";
    program = "${kodiPkg}/bin/kodi";
  };
}
