{ ... }:
{
  # Use a 16gb swapfile.
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
}
