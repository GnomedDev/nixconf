{ ... }:
{
  # Use the unfree nvidia drivers, with the open kernel module.
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
}
