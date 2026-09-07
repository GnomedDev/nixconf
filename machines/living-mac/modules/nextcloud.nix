{ config, pkgs, ... }:
let
  hostName = "${config.networking.hostName}.tail272b81.ts.net";
  port = 7640;
in
{
  services.nextcloud = {
    enable = true;
    inherit hostName;
    package = pkgs.nextcloud34;
    database.createLocally = true;
    https = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/var/certs/nextcloud-admin-pass";
    };
    settings = {
      trusted_domains = [ "${hostName}:${toString port}" ];
      maintenance_window_start = "4";
      default_phone_region = "GB";
      log_type = "systemd";
    };

    appstoreEnable = false;
  };

  services.nginx.virtualHosts."${config.services.nextcloud.hostName}" = {
    extraConfig = ''
      ssl_certificate      "/var/certs/${hostName}.crt";
      ssl_certificate_key  "/var/certs/${hostName}.key";
    '';
    listen = [
      {
        addr = "0.0.0.0";
        inherit port;
        ssl = true;
      }
    ];
  };

  environment.systemPackages = [ config.services.nextcloud.occ ];
}
