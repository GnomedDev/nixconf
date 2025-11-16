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

    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      nix-index-database,
      darwin,
      home-manager,
      plasma-manager,
      ...
    }:

    let
      nixPkgsConfig = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
      pkgsX86 = import nixpkgs {
        system = "x86_64-linux";
        config = nixPkgsConfig;
      };
      pkgsARM = import nixpkgs {
        system = "aarch64-linux";
        config = nixPkgsConfig;
      };
      pkgsARMDarwin = import nixpkgs {
        system = "aarch64-darwin";
        config = nixPkgsConfig;
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      homeConfigurations.gnome = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsARM;
        modules = [ ./common/users/gnome/home.nix ];
      };

      darwinConfigurations.gnome = darwin.lib.darwinSystem {
        pkgs = pkgsARMDarwin;
        specialArgs = { inherit nix-index-database; };
        modules = [
          home-manager.darwinModules.home-manager
          ./configuration.darwin.nix

          ./common/modules/home-manager.nix

          ./common/users/gnome/general.nix
          ./common/users/gnome/graphical.nix
          ./common/users/gnome/general.darwin.nix
        ];
      };

      nixosConfigurations.gnome-desktop = nixpkgs.lib.nixosSystem {
        pkgs = pkgsX86;
        specialArgs = {
          inherit plasma-manager;
          inherit nix-index-database;
        };
        modules = [
          ./configuration.nix

          ./common/modules/kde.nix
          ./common/modules/nvidia.nix
          ./common/modules/systemd-boot.nix
          ./common/modules/home-manager.nix

          ./common/users/gnome/general.nix
          ./common/users/gnome/graphical.nix
          ./common/users/gnome/kde.nix

          ./machines/gnome-desktop/modules/swapfile.nix
          ./machines/gnome-desktop/modules/wifi-firmware
          ./machines/gnome-desktop/modules/hardware-configuration.nix

          home-manager.nixosModules.home-manager
        ];
      };

      nixosConfigurations.gnome-x86-mac = nixpkgs.lib.nixosSystem {
        pkgs = pkgsX86;
        specialArgs = {
          inherit plasma-manager;
          inherit nix-index-database;
        };
        modules = [
          ./configuration.nix

          ./common/modules/kde.nix
          ./common/modules/systemd-boot.nix
          ./common/modules/home-manager.nix
          ./common/modules/disable-sleep.nix

          ./common/users/fox/general.nix
          ./common/users/gnome/general.nix

          ./machines/gnome-x86-mac/modules/t2fanrd
          ./machines/gnome-x86-mac/modules/swapfile.nix
          ./machines/gnome-x86-mac/modules/wifi-firmware
          ./machines/gnome-x86-mac/modules/substituter.nix
          ./machines/gnome-x86-mac/modules/hardware-configuration.nix

          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.apple-t2
        ];
      };

      nixosConfigurations.living-pi = nixpkgs.lib.nixosSystem {
        pkgs = pkgsARM;
        specialArgs = { inherit nix-index-database; };
        modules = [
          ./configuration.nix

          ./common/modules/home-manager.nix

          ./common/users/gnome/ssh.nix
          ./common/users/gnome/general.nix

          ./machines/living-pi/modules/boot.nix
          ./machines/living-pi/modules/kodi.nix
          ./machines/living-pi/modules/samba.nix
          ./machines/living-pi/modules/firmware.nix
          ./machines/living-pi/modules/swapfile.nix
          ./machines/living-pi/modules/networking.nix
          ./machines/living-pi/modules/remote-control.nix
          ./machines/living-pi/modules/hardware-configuration.nix

          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.raspberry-pi-4
        ];
      };
    };
}
