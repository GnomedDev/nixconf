{
  lib,
  pkgs,
  config,
  ttsServiceSrc,
  tailscaleHostname,
  ipv6Block,
  ...
}:
let
  cidr = "${ipv6Block}/64";
  oci-backend = "docker";

  getServiceName = name: config.systemd.services.${name}.name;
in
{
  systemd.services.setup-local-bind = {
    requiredBy = [ (getServiceName "${oci-backend}-tts-service") ];
    before = [ (getServiceName "${oci-backend}-tts-service") ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${lib.getExe' pkgs.iproute2 "ip"} route add local ${cidr} dev lo";
    };
  };

  virtualisation.oci-containers.backend = oci-backend;
  virtualisation.oci-containers.containers.tts-service = {
    image = "gnomeddev/tts-service:${ttsServiceSrc.rev}";
    volumes = [
      "/var/tts-service/gcloud_tts.json:/gcp.json"
    ];
    environmentFiles = [
      # AWS_ACCESS_KEY_ID=
      # AWS_SECRET_ACCESS_KEY=
      # DEEPL_KEY=
      "/var/tts-service/env"
    ];
    environment = {
      BIND_ADDR = "${tailscaleHostname}:58174";
      IPV6_BLOCK = cidr;
      LOG_LEVEL = "WARN";
      GOOGLE_APPLICATION_CREDENTIALS = "/gcp.json";
      AWS_REGION = "eu-central-1";
      CACHE_MAX_CAPACITY = lib.toString (2500 * 8); # Around 8gb of memory usage
    };
    extraOptions = [
      "--init"
      "--network=host"
      "--ulimit"
      "nofile=65535"
    ];
  };
}
