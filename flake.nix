{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    t2fanrd.url = "github:GnomedDev/t2fanrd";
    t2fanrd.inputs.nixpkgs.follows = "nixpkgs";

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
      t2fanrd,
      ...
    }:

    let
      nixpkgsConfig.config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
      pkgsX86 = import nixpkgs (nixpkgsConfig // { system = "x86_64-linux"; });
      pkgsARM = import nixpkgs (nixpkgsConfig // { system = "aarch64-linux"; });
      pkgsARMDarwin = import nixpkgs (nixpkgsConfig // { system = "aarch64-darwin"; });
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

          ./common/users/gnome/general
          ./common/users/gnome/general/darwin.nix
          ./common/users/gnome/graphical.nix
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

          ./common/users/gnome/general
          ./common/users/gnome/general/linux.nix
          ./common/users/gnome/graphical.nix
          ./common/users/gnome/kde.nix

          ./machines/gnome-desktop/modules/swapfile.nix
          ./machines/gnome-desktop/modules/wifi-firmware
          ./machines/gnome-desktop/modules/hardware-configuration.nix

          home-manager.nixosModules.home-manager
        ];
      };

      nixosConfigurations.living-mac = nixpkgs.lib.nixosSystem {
        pkgs = pkgsX86;
        specialArgs = { inherit nix-index-database; };
        modules = [
          ./configuration.nix

          ./common/modules/home-manager.nix
          ./common/modules/systemd-boot.nix
          ./common/modules/disable-sleep.nix

          ./common/users/gnome/general
          ./common/users/gnome/general/linux.nix

          ./common/users/fox/general.nix
          ./common/users/sleepy/general.nix

          ./machines/living-mac/modules/kodi.nix
          ./machines/living-mac/modules/samba.nix
          ./machines/living-mac/modules/swapfile.nix
          ./machines/living-mac/modules/firmware.nix
          ./machines/living-mac/modules/t2fanrd.nix
          ./machines/living-mac/modules/tailscale.nix
          ./machines/living-mac/modules/qbittorrent.nix
          ./machines/living-mac/modules/home-assistant.nix
          ./machines/living-mac/modules/hardware-configuration.nix

          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.apple-t2
          t2fanrd.nixosModules.t2fanrd
        ];
      };
    };
}
