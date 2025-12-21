{ ... }:
{
  # Enable T2 specific kernel drivers/wifi firmware.
  hardware.apple-t2.firmware.enable = true;

  # Use the T2 patches to set the battery limit to 80% via systemd.
  systemd.tmpfiles.settings = {
    "t2linux-battery-limit" = {
      "/sys/bus/acpi/drivers/applesmc/APP0001:00/battery_charge_limit" = {
        "f+" = {
          argument = "80";
          group = "root";
          user = "root";
          mode = "0644";
        };
      };
    };
  };

  # Enable power management via upower.
  services.upower.enable = true;

  # Setup networking.
  networking.hostName = "living-mac";
  networking.networkmanager.enable = true;
}
