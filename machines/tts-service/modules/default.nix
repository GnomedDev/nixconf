{
  lib,
  pkgs,
  config,
  tailscaleHostname,
  ipBlock,
  ...
}:
let
  cidr = "${ipBlock}/64";
  oci-backend = config.virtualisation.oci-containers.backend;

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

  services.tts-service = {
    enable = true;
    bindAddr = "${tailscaleHostname}:58174";
    secrets = {
      envFile = "/var/tts-service/env";
      googleServiceAccountPath = "/var/tts-service/gcloud_tts.json";
    };
    settings = {
      ipv6Block = cidr;
      cacheMaxCapacity = 4000 * 8; # Around 8gb of memory usage
    };
  };
}
