{
  lib,
  modulesPath,
  ipv4Addr,
  ipv6Block,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  swapDevices = [ ];

  boot.loader.grub.device = "/dev/sda";

  systemd.network = {
    enable = true;
    networks."10-internet" = {
      matchConfig.Name = "ens18";
      linkConfig.RequiredForOnline = "routable";

      address = [
        "${ipv4Addr}/24"
        "${ipv6Block}/64"
      ];
      routes = [
        {
          Gateway = "77.237.232.1";
          GatewayOnLink = true;
        }
        {
          Gateway = "fe80::1";
          GatewayOnLink = true;
        }
      ];
      dns = [
        "79.143.183.251"
        "79.143.183.252"
      ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
