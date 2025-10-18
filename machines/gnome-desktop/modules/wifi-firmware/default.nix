{ config, pkgs, ... }:
{
  hardware.usb-modeswitch.enable = true;

  networking.networkmanager = {
    wifi.backend = "iwd";
    enable = true;
  };

  boot.extraModulePackages = with pkgs; [
    (config.boot.kernelPackages.callPackage ./rtw89.nix { })
  ];
}
