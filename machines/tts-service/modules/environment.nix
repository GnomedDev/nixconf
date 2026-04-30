{ tailscaleHostname, ... }:
{
  services.cloud-init = {
    enable = true;
    network.enable = true;
    ext4.enable = false;
    btrfs.enable = false;
    xfs.enable = false;
  };

  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = tailscaleHostname;
    enabledCollectors = [ "processes" ];
  };

  boot.kernel.sysctl."net.ipv6.ip_nonlocal_bind" = "1";
  networking.useNetworkd = true;

  security.sudo.wheelNeedsPassword = false;
}
