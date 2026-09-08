{ config, sharePath, ... }:
{
  services.immich = {
    enable = true;
    host = "0.0.0.0";

    mediaLocation = "${sharePath}/Photos/Immich";
    accelerationDevices = [ "/dev/dri/renderD128" ];
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  services.nginx.virtualHosts."photos.t4t.fail" = {
    useACMEHost = "t4t.fail";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.immich.port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
