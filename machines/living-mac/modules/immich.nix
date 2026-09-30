{ config, sharePath, ... }:
{
  services.immich = {
    enable = true;
    host = "127.0.0.1";

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
    quic = true;
    http3 = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.immich.port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
    extraConfig = ''
      # allow large file uploads
      client_max_body_size 50000M;

      # disable buffering uploads to prevent OOM on reverse proxy server and make uploads twice as fast (no pause)
      proxy_request_buffering off;

      # increase body buffer to avoid limiting upload speed
      client_body_buffer_size 1024k;
    '';
  };
}
