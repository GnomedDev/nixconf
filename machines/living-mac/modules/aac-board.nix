{
  config,
  pkgs,
  lib,
  aac-board,
  tts-service,
  ...
}:
{
  services.nginx.virtualHosts."aac.t4t.cloud" = {
    quic = true;
    http3 = true;
    forceSSL = true;
    useACMEHost = "t4t.fail";

    root = aac-board.packages.${pkgs.stdenv.buildPlatform.system}.default;
    locations."/api/".proxyPass =
      "http://${config.systemd.services.tts-service.environment.BIND_ADDR}/";
    locations."/images".extraConfig = ''
      autoindex on;
      autoindex_format json;
    '';
  };

  systemd.services.tts-service = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "network-online.target"
      "tailscaled.service"
    ];
    requires = [
      "network-online.target"
      "tailscaled.service"
    ];
    serviceConfig = {
      ExecStart = lib.getExe tts-service.packages.${pkgs.stdenv.targetPlatform.system}.default;
      EnvironmentFile = [ "/var/certs/aws-aac-credentials.env" ];
      LimitNOFILE = "infinity";
    };
    environment = {
      LOG_LEVEL = "WARN";

      BIND_ADDR = "localhost:58174";
      IPV6_BLOCK = "DISABLE";
      CACHE_MAX_CAPACITY = lib.toString 1000;
      GOOGLE_APPLICATION_CREDENTIALS = "/var/certs/gcp-aac-credentials.json";
    };
  };
}
