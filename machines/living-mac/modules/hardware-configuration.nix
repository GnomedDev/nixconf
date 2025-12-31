{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/01232bdf-06f7-4b06-83c0-9fba43cd7131";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "ssd"
    ];
  };

  fileSystems."/mnt/ext-hdd" = {
    device = "/dev/disk/by-uuid/0ecaf241-a3ea-43e4-b138-52c379c23f6a";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "nofail"
      "ssd"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/42E2-1917";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
