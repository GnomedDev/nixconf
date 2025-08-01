{ pkgs, ... }:

{
  # Enable Raspberry Pi support in libcec
  nixpkgs.overlays = [
    (self: super: { libcec = super.libcec.override { withLibraspberrypi = true; }; })
  ];

  # Install libcec, the library for HDMI-CEC
  environment.systemPackages = with pkgs; [
    libcec
  ];

  # Allow `video` group to access the CEC connection
  services.udev.extraRules = ''KERNEL=="vchiq", GROUP="video", MODE="0660"'';
}
