{
  lib,
  config,
  sharePath,
  ...
}:
let
  exposeToLan = config.networking.hostName == "living-nuc";
in
{
  services.qbittorrent = {
    enable = true;
    webuiPort = 20036;
    torrentingPort = 31766;
    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences = {
        Queueing.QueueingEnabled = false;
        Downloads.DefaultSavePath = "${sharePath}/Torrenting";
        WebUI = {
          # Allow any connections from Tailscale skip authentication.
          AuthSubnetWhitelist = "100.64.0.0/10";
          AuthSubnetWhitelistEnabled = true;
          ReverseProxySupportEnabled = true;
          TrustedReverseProxiesList = "127.0.0.1";

          Address = if exposeToLan then "0.0.0.0" else "127.0.0.1";
          HTTPS = lib.optionalAttrs exposeToLan {
            Enabled = true;
            KeyPath = "/var/certs/${config.networking.hostName}.tail272b81.ts.net.key";
            CertificatePath = "/var/certs/${config.networking.hostName}.tail272b81.ts.net.crt";
          };
        };
      };
    };
  };

  services.nginx.virtualHosts."qbit.t4t.fail" = lib.optionalAttrs (!exposeToLan) {
    useACMEHost = "t4t.fail";
    forceSSL = true;
    quic = true;
    http3 = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.qbittorrent.webuiPort}";
      recommendedProxySettings = true;
    };
  };

  # Set qBittorrent's IO scheduler config to only use HDD when nothing else wants it.
  systemd.services.qbittorrent.serviceConfig.IOSchedulingClass = "idle";
}
