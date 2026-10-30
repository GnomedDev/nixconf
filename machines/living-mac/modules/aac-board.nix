{
  config,
  pkgs,
  aac-board,
  ...
}:
{
  services.nginx.virtualHosts."aac.t4t.cloud" = {
    quic = true;
    http3 = true;
    forceSSL = true;
    useACMEHost = "t4t.fail";

    root = aac-board.packages.${pkgs.stdenv.buildPlatform.system}.default;
    locations."/api/".proxyPass = "http://${config.services.tts-service.bindAddr}/";
    locations."/images".extraConfig = ''
      autoindex on;
      autoindex_format json;
    '';
  };

  services.tts-service = {
    enable = true;
    bindAddr = "localhost:58174";
    secrets = {
      envFile = "/var/certs/aws-aac-credentials.env";
      googleServiceAccountPath = "/var/certs/gcp-aac-credentials.json";
    };
    settings = {
      ipv6Block = "DISABLE";
      cacheMaxCapacity = 1000;
    };
  };
}
