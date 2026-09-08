{ pkgs,... }: {
  services.unifi = {
    enable = true;
    mongodbPackage = pkgs.mongodb-ce;
  };

  services.nginx.virtualHosts."unifi.t4t.fail" = {
    useACMEHost = "t4t.fail";
    forceSSL = true;
    locations."/" = {
      proxyPass = "https://living-mac:8443";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
