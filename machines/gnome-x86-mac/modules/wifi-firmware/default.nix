{ pkgs, ... }:

{
  # Use NetworkManager with IWD for stable WiFI on T2
  networking.hostName = "gnome-x86-mac";
  networking.networkmanager = {
    wifi.backend = "iwd";
    enable = true;
  };

  hardware.firmware = [
    (pkgs.stdenvNoCC.mkDerivation (final: {
      name = "brcm-firmware";
      src = ./brcm;
      installPhase = ''
        mkdir -p $out/lib/firmware/brcm;
        cp ${final.src}/* "$out/lib/firmware/brcm"
      '';
    }))
  ];
}
