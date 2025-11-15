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

  # Do not change.
  system.stateVersion = 6;
}
