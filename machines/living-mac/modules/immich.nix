{ ... }:
{
  services.immich = {
    enable = true;
    host = "0.0.0.0";

    mediaLocation = "/mnt/ext-hdd/Photos/Immich";

    machine-learning.enable = false;
    accelerationDevices = [ "/dev/dri/renderD128" ];
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];
}
