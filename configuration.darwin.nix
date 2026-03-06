{ pkgs, ... }:

{
  # Disable nix-darwin configuration of Nix, as it is managed by Determinate.
  nix.enable = false;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    nano
    curl
    btop
  ];

  # Allow sudo to authenticate with touch ID
  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  system.defaults.hitoolbox.AppleFnUsageType = "Do Nothing";
  system.defaults.screencapture.target = "clipboard";
  system.defaults.dock.autohide = true;
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    FXPreferredViewStyle = "Nlsv"; # List View
    FXRemoveOldTrashItems = true;
    NewWindowTarget = "Home";
    ShowStatusBar = true;
  };
  system.defaults.controlcenter = {
    BatteryShowPercentage = true;
    AirDrop = false;
  };
  system.defaults.NSGlobalDomain = {
    # Treat the F keys normally, toggle to special when pressing Fn
    "com.apple.keyboard.fnState" = true;
    AppleInterfaceStyle = "Dark";
    KeyRepeat = 2;
  };
  # TODO: Specific to me, set with home-manager?
  system.defaults.dock.persistent-apps = [
    { app = "/System/Applications/Apps.app"; }
    { app = "${pkgs.firefox}/Applications/Firefox.app"; }
    { app = "${pkgs.vesktop}/Applications/Vesktop.app"; }
    { app = "${pkgs.zed-editor}/Applications/Zed.app"; }
    { app = "${pkgs.ghostty-bin}/Applications/Ghostty.app"; }
  ];

  # Do not change.
  system.stateVersion = 6;
}
