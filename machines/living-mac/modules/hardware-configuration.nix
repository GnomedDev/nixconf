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
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "nvme"
    "usb_storage"
    "dm-cache-default"
    "dm-snapshot"
    "uas"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelPatches = [
    {
      name = "Reduce compile time by removing support for unused features";
      patch = null;
      structuredExtraConfig =
        with lib.kernel;
        lib.mapAttrs (_: value: lib.mkForce value) {
          # Debugging over network, have physical access
          NETCONSOLE = no;
          NETCONSOLE_DYNAMIC = unset;

          # Don't need to KEXEC
          KEXEC = no;
          KEXEC_HANDOVER = no;

          # WIFI/BT hardware is buggy
          WLAN = no;
          BRCMFMAC = unset;
          RT2800USB_RT53XX = unset;
          RT2800USB_RT55XX = unset;
          RTW88 = unset;
          RTW88_8822BE = unset;
          RTW88_8822CE = unset;
          BT = no;
          BT_HCIUART_BCSP = unset;
          BT_HCIUART_H4 = unset;
          BT_HCIUART_LL = unset;
          BT_RFCOMM_TTY = unset;
          BT_BCM = unset;
          BT_HCIBCM4377 = unset;
          BT_HCIBTUSB_AUTOSUSPEND = unset;
          BT_HCIBTUSB_MTK = unset;
          BT_HCIUART = unset;
          BT_HCIUART_BCM = unset;
          BT_HCIUART_QCA = unset;
          BT_HCIUART_SERDEV = unset;
          BT_QCA = unset;

          # Not in a VM
          HYPERVISOR_GUEST = no;
          HYPERV = unset;
          DRM_HYPERV = unset;
          INTEL_TDX_GUEST = unset;
          TDX_GUEST_DRIVER = unset;
          PARAVIRT_TIME_ACCOUNTING = unset;
          KVM_GUEST = unset;
          KVM_AMD_SEV = unset;
          SEV_GUEST = unset;

          # Not using Nvidia hardware
          DRM_NOUVEAU = no;
          FB_NVIDIA = no;
          FB_NVIDIA_I2C = unset;
          NVIDIA_WMI_EC_BACKLIGHT = no;

          # Not using AMD hardware
          PROCESSOR_SELECT = yes;
          CPU_SUP_AMD = no;
          CRYPTO_DEV_CCP = no;
          DRM_AMDGPU = no;
          DRM_RADEON = no;
          AMD_HFI = unset;
          AMD_MEM_ENCRYPT = unset;
          HSA_AMD = unset;
          HSA_AMD_P2P = unset;
          DEVICE_PRIVATE = unset;
          DRM_AMDGPU_CIK = unset;
          DRM_AMDGPU_SI = unset;
          DRM_AMDGPU_USERPTR = unset;
          DRM_AMD_ACP = unset;
          DRM_AMD_DC_FP = unset;
          DRM_AMD_DC_SI = unset;
          DRM_AMD_ISP = unset;
          DRM_AMD_SECURE_DISPLAY = unset;
          DRM_NOUVEAU_SVM = unset;

          # Not using Chrome hardware
          CHROME_PLATFORMS = no;
          CROS_EC = unset;
          CROS_EC_I2C = unset;
          CROS_EC_ISHTP = unset;
          CROS_EC_LPC = unset;
          CROS_EC_SPI = unset;
          CROS_KBD_LED_BACKLIGHT = unset;
          CHROMEOS_LAPTOP = unset;
          CHROMEOS_PSTORE = unset;
          CHROMEOS_TBMC = unset;

          # Not using weird CPUs
          CPU_SUP_HYGON = no;
          CPU_SUP_CENTAUR = no;
          CPU_SUP_ZHAOXIN = no;

          # Not using a gamepad
          GAMEPORT = no;
          HID_ACRUX = no;
          HID_DRAGONRISE = no;
          HID_GREENASIA = no;
          HID_HOLTEK = no;
          INPUT_JOYSTICK = no;
          HID_NINTENDO = no;
          HID_PLAYSTATION = no;
          HID_SONY = no;
          HID_SMARTJOYPLUS = no;
          HID_THRUSTMASTER = no;
          HID_ZEROPLUS = no;
          DRAGONRISE_FF = unset;
          GREENASIA_FF = unset;
          HID_ACRUX_FF = unset;
          HOLTEK_FF = unset;
          JOYSTICK_PSXPAD_SPI_FF = unset;
          ZEROPLUS_FF = unset;
          THRUSTMASTER_FF = unset;
          SONY_FF = unset;
          SMARTJOYPLUS_FF = unset;
          PLAYSTATION_FF = unset;
          LOGIG940_FF = unset;
          LOGIRUMBLEPAD2_FF = unset;
          LOGITECH_FF = unset;
          LOGIWHEELS_FF = unset;
          NVIDIA_SHIELD_FF = unset;
          NINTENDO_FF = unset;
          MOUSE_PS2_VMMOUSE = unset;

          # Not using a touchscreen
          INPUT_TOUCHSCREEN = no;

          # Not using Zram
          ZRAM = no;
          ZRAM_BACKEND_842 = unset;
          ZRAM_BACKEND_DEFLATE = unset;
          ZRAM_BACKEND_LZ4 = unset;
          ZRAM_BACKEND_LZ4HC = unset;
          ZRAM_BACKEND_LZO = unset;
          ZRAM_BACKEND_ZSTD = unset;
          ZRAM_DEF_COMP_ZSTD = unset;
          ZRAM_MULTI_COMP = unset;

          # Not sleeping
          SUSPEND = no;

          # Clear out unnecessary networking drivers
          NET_VENDOR_3COM = no;
          NET_VENDOR_ADAPTEC = no;
          NET_VENDOR_AGERE = no;
          NET_VENDOR_ALACRITECH = no;
          NET_VENDOR_ALIBABA = no;
          NET_VENDOR_AMAZON = no;
          NET_VENDOR_AMD = no;
          NET_VENDOR_AQUANTIA = no;
          NET_VENDOR_ARC = no;
          NET_VENDOR_ASIX = no;
          NET_VENDOR_ATHEROS = no;
          # NET_VENDOR_BROADCOM=no;
          NET_VENDOR_CADENCE = no;
          NET_VENDOR_CAVIUM = no;
          NET_VENDOR_CORTINA = no;
          NET_VENDOR_DAVICOM = no;
          NET_VENDOR_DEC = no;
          NET_VENDOR_DLINK = no;
          NET_VENDOR_ENGLEDER = no;
          NET_VENDOR_EZCHIP = no;
          NET_VENDOR_FUNGIBLE = no;
          NET_VENDOR_GOOGLE = no;
          NET_VENDOR_HISILICON = no;
          NET_VENDOR_HUAWEI = no;
          NET_VENDOR_INTEL = no;
          NET_VENDOR_ADI = no;
          NET_VENDOR_LITEX = no;
          NET_VENDOR_MARVELL = no;
          NET_VENDOR_META = no;
          NET_VENDOR_MICREL = no;
          NET_VENDOR_MICROCHIP = no;
          NET_VENDOR_MICROSEMI = no;
          NET_VENDOR_MICROSOFT = no;
          NET_VENDOR_MUCSE = no;
          NET_VENDOR_MYRI = no;
          NET_VENDOR_NI = no;
          NET_VENDOR_NATSEMI = no;
          NET_VENDOR_NETRONOME = no;
          NET_VENDOR_NVIDIA = no;
          NET_VENDOR_OKI = no;
          NET_VENDOR_PENSANDO = no;
          NET_VENDOR_QLOGIC = no;
          NET_VENDOR_BROCADE = no;
          NET_VENDOR_QUALCOMM = no;
          NET_VENDOR_RDC = no;
          # NET_VENDOR_REALTEK=no;
          NET_VENDOR_RENESAS = no;
          NET_VENDOR_ROCKER = no;
          NET_VENDOR_SAMSUNG = no;
          NET_VENDOR_SEEQ = no;
          NET_VENDOR_SILAN = no;
          NET_VENDOR_SIS = no;
          NET_VENDOR_SOLARFLARE = no;
          NET_VENDOR_SMSC = no;
          NET_VENDOR_SOCIONEXT = no;
          NET_VENDOR_STMICRO = no;
          NET_VENDOR_SUN = no;
          NET_VENDOR_SYNOPSYS = no;
          NET_VENDOR_TEHUTI = no;
          NET_VENDOR_TI = no;
          NET_VENDOR_VERTEXCOM = no;
          NET_VENDOR_VIA = no;
          NET_VENDOR_WANGXUN = no;
          NET_VENDOR_WIZNET = no;
          NET_VENDOR_XILINX = no;
          NET_VENDOR_XIRCOM = no;
          NET_FC = no;
          INFINIBAND = no;
          INFINIBAND_IPOIB = unset;
          INFINIBAND_IPOIB_CM = unset;

          # Don't care for sound
          SOUND = no;
          SND_AC97_POWER_SAVE = unset;
          SND_AC97_POWER_SAVE_DEFAULT = unset;
          SND_DYNAMIC_MINORS = unset;
          SND_HDA_CODEC_CS8409 = unset;
          SND_HDA_INPUT_BEEP = unset;
          SND_HDA_PATCH_LOADER = unset;
          SND_HDA_POWER_SAVE_DEFAULT = unset;
          SND_HDA_RECONFIG = unset;
          SND_OSSEMUL = unset;
          SND_PCM = unset;
          SND_SOC_INTEL_SOUNDWIRE_SOF_MACH = unset;
          SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES = unset;
          SND_SOC_SOF_ACPI = unset;
          SND_SOC_SOF_APOLLOLAKE = unset;
          SND_SOC_SOF_CANNONLAKE = unset;
          SND_SOC_SOF_COFFEELAKE = unset;
          SND_SOC_SOF_COMETLAKE = unset;
          SND_SOC_SOF_ELKHARTLAKE = unset;
          SND_SOC_SOF_GEMINILAKE = unset;
          SND_SOC_SOF_HDA_AUDIO_CODEC = unset;
          SND_SOC_SOF_HDA_LINK = unset;
          SND_SOC_SOF_ICELAKE = unset;
          SND_SOC_SOF_INTEL_TOPLEVEL = unset;
          SND_SOC_SOF_JASPERLAKE = unset;
          SND_SOC_SOF_MERRIFIELD = unset;
          SND_SOC_SOF_PCI = unset;
          SND_SOC_SOF_TIGERLAKE = unset;
          SND_SOC_SOF_TOPLEVEL = unset;
          SND_USB_AUDIO_MIDI_V2 = unset;
          SND_USB_CAIAQ_INPUT = unset;
          T2BCE_AUDIO = unset;

          # Misc and obvious
          MEDIA_SUPPORT = no;
          MEDIA_ATTACH = unset;
          MEDIA_CONTROLLER = unset;
          MEDIA_ANALOG_TV_SUPPORT = unset;
          MEDIA_CAMERA_SUPPORT = unset;
          MEDIA_DIGITAL_TV_SUPPORT = unset;
          MEDIA_PCI_SUPPORT = unset;
          MEDIA_USB_SUPPORT = unset;
          X86_PLATFORM_DRIVERS_DELL = no;
          X86_PLATFORM_DRIVERS_HP = no;
          IIO = no;
          HID_SENSOR_ALS = unset;
          GNSS = no;
          WWAN = no;
        };
    }
  ];

  services.lvm.boot.thin.enable = true;

  fileSystems."/" = {
    device = "/dev/pool/main";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B712-7B97";
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
