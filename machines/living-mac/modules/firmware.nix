{ ... }:
{
  hardware.apple-t2.firmware.enable = true;
  services.upower.enable = true;

  networking.hostName = "living-mac";
  networking.networkmanager.enable = true;
}
