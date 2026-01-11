{ config, rtw89Src, ... }:
{
  hardware.usb-modeswitch.enable = true;

  networking.networkmanager = {
    wifi.backend = "iwd";
    enable = true;
  };

  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ./rtw89.nix { inherit rtw89Src; })
  ];
}
