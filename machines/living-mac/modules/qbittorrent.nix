# Required stateful files:
# /var/certs contains HTTPS certificates
{ ... }:
{
  services.qbittorrent = {
    enable = true;
    webuiPort = 20036;
    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences.WebUI = {
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
}
