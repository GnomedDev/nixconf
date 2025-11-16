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
    nixfmt
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

  # Do not change.
  system.stateVersion = 6;
}
