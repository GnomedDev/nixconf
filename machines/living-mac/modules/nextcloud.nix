{ config, pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    hostName = "cloud.t4t.fail";
    package = pkgs.nextcloud34;
    database.createLocally = true;
    https = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/var/certs/nextcloud-admin-pass";
    };
    settings = {
      maintenance_window_start = "4";
      default_phone_region = "GB";
      log_type = "systemd";
    };

    appstoreEnable = false;
    extraApps = {
      inherit (pkgs.nextcloud34Packages.apps) calendar contacts spreed;
    };
  };

  services.nextcloud-spreed-signaling = {
    enable = true;
    configureNginx = true;
    hostName = "talk.t4t.fail";
    settings = {
      http.listen = "localhost:7787";
      clients.internalsecretFile = "/var/certs/nextcloud-talk.internalSecret";
      sessions = {
        blockkeyFile = "/var/certs/nextcloud-talk.blockSecret";
        hashkeyFile = "/var/certs/nextcloud-talk.hashSecret";
      };
    };
    backends.nextcloud = {
      urls = [ "https://${config.services.nextcloud.hostName}" ];
      secretFile = "/var/certs/nextcloud-talk.secret";
    };
  };

  services.nginx.virtualHosts =
    let
      h3WithSSL = {
        quic = true;
        http3 = true;
        forceSSL = true;
        useACMEHost = "t4t.fail";
      };
    in
    {
      "${config.services.nextcloud.hostName}" = h3WithSSL;
      "${config.services.nextcloud-spreed-signaling.hostName}" = h3WithSSL;
    };

  environment.systemPackages = [ config.services.nextcloud.occ ];
}
