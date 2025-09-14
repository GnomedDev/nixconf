{ home-manager, plasma-manager, ... }:
{
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
}
