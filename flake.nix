{
  nixConfig = {
    extra-substituters = [
      "https://cache.soopy.moe"
    ];
    extra-trusted-public-keys = [ "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      home-manager,
      ...
    }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      nixosConfigurations.gnome-x86-mac = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./common/modules/git.nix
          ./common/modules/home-manager.nix
          ./common/modules/disable-sleep.nix
          ./machines/gnome-x86-mac/modules/t2fanrd
          ./machines/gnome-x86-mac/modules/boot.nix
          ./machines/gnome-x86-mac/modules/wifi-firmware
          ./machines/gnome-x86-mac/modules/substituter.nix
          ./machines/gnome-x86-mac/modules/hardware-configuration.nix

          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.apple-t2
        ];
      };

      nixosConfigurations.living-pi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./configuration.nix
          ./common/modules/git.nix
          ./common/modules/home-manager.nix

          ./machines/living-pi/modules/boot.nix
          ./machines/living-pi/modules/kodi.nix
          ./machines/living-pi/modules/networking.nix
          ./machines/living-pi/modules/hardware-configuration.nix

          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.raspberry-pi-4
        ];
      };
    };
}
