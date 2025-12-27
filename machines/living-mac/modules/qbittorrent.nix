# Required state:
# - /var/certs contains HTTPS certificates
# - Router is set up to port forward TCP/UDP on 31766 to living-mac
{ ... }:
{
  services.qbittorrent = {
    enable = true;
    webuiPort = 20036;
    torrentingPort = 31766;
    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences = {
        Queueing.QueueingEnabled = false;
        Downloads.DefaultSavePath = "/mnt/ext-hdd/Torrenting";
        WebUI = {
          # Allow any connections from Tailscale skip authentication.
          AuthSubnetWhitelist = "100.64.0.0/10";
          AuthSubnetWhitelistEnabled = true;

          HTTPS = {
            Enabled = true;
            KeyPath = "/var/certs/living-mac.tail272b81.ts.net.key";
            CertificatePath = "/var/certs/living-mac.tail272b81.ts.net.crt";
          };
        };
      };
    };
  };

  # Set qBittorrent's IO scheduler config to only use HDD when nothing else wants it.
  systemd.services.qbittorrent.serviceConfig.IOSchedulingClass = "idle";
}
