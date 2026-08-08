{
  tailscaleHostname,
  ipBlock,
  pkgs,
  ...
}:
let
  cidr = "${ipBlock}/64";
  interface = if pkgs.stdenv.targetPlatform.system == "x86_64-linux" then "enp0s3" else "enp7s0";
in
{
  # Spread IRQ load across cores, for an attempt to reduce load.
  services.irqbalance.enable = true;

  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = tailscaleHostname;
    enabledCollectors = [ "processes" ];
  };

  boot.kernel.sysctl."net.ipv6.ip_nonlocal_bind" = "1";
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks."10-ethernet" = {
      enable = true;
      matchConfig.Name = interface;
      networkConfig = {
        DHCP = "yes";
        Address = cidr;
        IPv6PrivacyExtensions = "kernel";
      };
    };
  };

  services.ndppd = {
    enable = true;
    proxies.${interface}.rules.${cidr}.method = "static";
  };

  security.sudo.wheelNeedsPassword = false;
}
