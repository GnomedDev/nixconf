{ tailscaleHostname, ... }:
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

  security.sudo.wheelNeedsPassword = false;
}
