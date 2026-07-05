{
  lib,
  ipv6Block,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../../common/modules/systemd-boot.nix
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "usbhid"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/vda2";
    fsType = "vfat";
  };

  swapDevices = [ ];

  systemd.network = {
    enable = true;
    networks."10-ethernet" = {
      enable = true;
      matchConfig.Name = "enp7s0";
      networkConfig = {
        DHCP = "yes";
        Address = "${ipv6Block}/64";
        IPv6PrivacyExtensions = "kernel";
      };
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
