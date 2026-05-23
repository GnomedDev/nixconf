{ ... }:
{
  # Enable power management via upower.
  services.upower.enable = true;

  # Setup networking.
  networking.hostName = "living-nuc";
  services.resolved.enable = true;
}
