{
  pkgs,
  home-manager,
  plasma-manager,
  ...
}:
{
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];

  # Get rid of plasma packages that we don't need
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    ktexteditor
    khelpcenter
    elisa
    kate
  ];
}
