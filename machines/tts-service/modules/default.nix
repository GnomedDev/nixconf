{ pkgs, config, ... }:
let
  oci-backend = "docker";
  ipEnvPath = "/var/tts-service/ip.env";

  getServiceName = name: config.systemd.services.${name}.name;
in
{
  systemd.services.setup-local-bind = {
    requiredBy = [ (getServiceName "${oci-backend}-tts-service") ];
    before = [ (getServiceName "${oci-backend}-tts-service") ];
    after = [ (getServiceName "cloud-init") ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    path = with pkgs; [
      iproute2
      hostname-debian
    ];
    script = ''
      for addr in $(hostname -I); do
          if [[ $addr == *"::1" ]] then
              block=''${addr%1}/64
              ip route add local $block dev lo

              echo IPV6_BLOCK=$block > ${ipEnvPath}
          fi
      done
    '';
  };

  virtualisation.oci-containers.backend = oci-backend;
  virtualisation.oci-containers.containers.tts-service = {
    image = "gnomeddev/tts-service:dispatch";
    volumes = [
      "/var/tts-service/gcloud_tts.json:/gcp.json"
    ];
    environmentFiles = [
      # BIND_ADDR={hostname}:58174;
      # AWS_ACCESS_KEY_ID=
      # AWS_SECRET_ACCESS_KEY=
      # DEEPL_KEY=
      "/var/tts-service/env"
      "${ipEnvPath}"
    ];
    environment = {
      LOG_LEVEL = "WARN";
      GOOGLE_APPLICATION_CREDENTIALS = "/gcp.json";
      AWS_REGION = "eu-central-1";
      CACHE_MAX_CAPACITY = "75000"; # Around 6gb of memory usage
    };
    extraOptions = [
      "--network=host"
      "--ulimit"
      "nofile=65535"
    ];
  };

}
