{ ... }:
{
  hardware.apple-t2.firmware.enable = true;
  services.upower.enable = true;

  # Use NetworkManager with IWD for stable WiFI on T2
  networking.hostName = "living-mac";
  networking.networkmanager = {
    unmanaged = [ "type:ethernet" ];
    wifi.backend = "iwd";
    enable = true;
  };
}
