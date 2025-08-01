{ ... }:
{
  # Use a 16gb swapfile.
  swapDevices = [
    {
      device = "/mnt/ext-hdd/swapfile";
      size = 16 * 1024;
    }
  ];
}
