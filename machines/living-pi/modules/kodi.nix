{ pkgs, ... }:

let
  kodiPkg = pkgs.kodi-gbm;
in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      kodi-gbm = super.kodi-gbm.override {
        pipewireSupport = false;
        opticalSupport = false;
        waylandSupport = false;
        pulseSupport = false;
        x11Support = false;
      };
    })
  ];

  # Enable the ALSA for Kodi Audio.
  hardware.alsa.enable = true;

  # Enable graphical drivers.
  hardware.graphics.enable = true;

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
