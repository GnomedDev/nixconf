{
  lib,
  pkgs,
  config,
  tts-service,
  ...
}:
let
  inherit (lib) mkIf mkOption mkEnableOption;
  cfg = config.services.tts-service;
in
{
  options.services.tts-service = with lib.types; {
    enable = mkEnableOption "TTS Service";

    bindAddr = mkOption { type = str; };
    secrets = mkOption {
      type = submodule {
        options = {
          googleServiceAccountPath = mkOption { type = externalPath; };
          envFile = mkOption {
            type = externalPath;
            description = ''
              - DEEPL_KEY
              - AWS_REGION
              - AWS_ACCESS_KEY_ID
              - AWS_SECRET_ACCESS_KEY
            '';
          };
        };
      };
    };

    settings = mkOption {
      type = submodule {
        options = {
          ipv6Block = mkOption {
            type = nullOr str;
            example = "2a01:4f8:120:24e1::2/64";
          };

          cacheMaxCapacity = mkOption {
            type = nullOr int;
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.tts-service = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "tailscaled.service" ];
      requires = [ "network-online.target" "tailscaled.service" ];
      serviceConfig = {
        ExecStart = lib.getExe tts-service.packages.${pkgs.stdenv.targetPlatform.system}.default;
        EnvironmentFile = [ cfg.secrets.envFile ];
        LimitNOFILE = "infinity";
      };
      environment = {
        LOG_LEVEL = "WARN";

        BIND_ADDR = cfg.bindAddr;
        IPV6_BLOCK = cfg.settings.ipv6Block;
        CACHE_MAX_CAPACITY = lib.toString cfg.settings.cacheMaxCapacity;
        GOOGLE_APPLICATION_CREDENTIALS = cfg.secrets.googleServiceAccountPath;
      };
    };
  };
}
