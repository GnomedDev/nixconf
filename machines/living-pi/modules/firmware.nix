{ pkgs, ... }:

{
  # Enable Raspberry Pi GPU drivers
  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
  hardware.raspberry-pi."4".fkms-3d.enable = true;
  hardware.deviceTree.enable = true;

  # Install Raspberry Pi management commands
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];
}
