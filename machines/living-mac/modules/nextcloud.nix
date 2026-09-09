{ config, pkgs, ... }:
let
  hostName = "cloud.t4t.fail";
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
      maintenance_window_start = "4";
      default_phone_region = "GB";
      log_type = "systemd";
    };

    appstoreEnable = false;
    extraApps = {
      inherit (pkgs.nextcloud34Packages.apps) calendar contacts spreed;
    };
  };

  # services.nextcloud-spreed-signaling = {
  #   enable = true;
  #   configureNginx = true;
  # };

  services.nginx.virtualHosts."${hostName}" = {
    quic = true;
    http3 = true;
    forceSSL = true;
    useACMEHost = "t4t.fail";
  };

  environment.systemPackages = [ config.services.nextcloud.occ ];
}
