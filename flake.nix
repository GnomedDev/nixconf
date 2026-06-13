{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware-unpatched.url = "github:NixOS/nixos-hardware";
    nixos-hardware-unpatched.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    t2fanrd.url = "github:GnomedDev/t2fanrd/feat/min-max-override";
    t2fanrd.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    # Raw inputs
    machSrc = {
      type = "github";
      owner = "cloudflare";
      repo = "networkquality-rs";
      flake = false;
    };
    foxessModbusSrc = {
      type = "github";
      owner = "nathanmarlor";
      repo = "foxess_modbus";
      flake = false;
    };
    jninja2TemplateSrc = {
      type = "github";
      owner = "PiotrMachowski";
      repo = "Home-Assistant-Lovelace-HTML-Jinja2-Template-card";
      flake = false;
    };
    powerFlowCardSrc = {
      type = "github";
      owner = "flixlix";
      repo = "power-flow-card-plus";
      flake = false;
    };
    myEnergiSrc = {
      type = "github";
      owner = "CJNE";
      repo = "ha-myenergi";
      flake = false;
    };
    ttsServiceSrc = {
      type = "github";
      owner = "Discord-TTS";
      repo = "tts-service";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware-unpatched,
      darwin,
      home-manager,
      t2fanrd,
      ...
    }@inputs:

    let
      lib = nixpkgs.lib;
      pkgs = lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        }
      );

      nixos-hardware =
        pkgs:
        pkgs.applyPatches {
          name = "nixos-hardware-patched";
          src = nixos-hardware-unpatched;
          patches = [
            (pkgs.fetchpatch2 {
              url = "https://github.com/NixOS/nixos-hardware/pull/1848.patch";
              hash = "sha256-Te4XV3mPQ5stCuQ9/yK567w8PvP7K7cIRtVyEEiHLjY=";
            })
          ];
        };

      specialArgs = inputs;
      mkTTSServices =
        index:
        let
          serviceSpecialArgs = specialArgs // {
            tailscaleHostname = "tts-service-${index}";
          };
          modules = [
            ./configuration.nix

            ./common/modules/home-manager.nix
            ./common/modules/systemd-boot.nix
            ./common/modules/disable-sleep.nix
            ./common/modules/tailscale-server.nix

            ./common/users/gnome/general
            ./common/users/gnome/general/linux.nix

            ./machines/tts-service/modules/environment.nix
            ./machines/tts-service/modules/hardware-configuration.nix

            home-manager.nixosModules.home-manager
          ];
        in
        {
          "tts-service-${index}" = nixpkgs.lib.nixosSystem {
            pkgs = pkgs.x86_64-linux;
            specialArgs = serviceSpecialArgs;
            modules = modules ++ [ ./machines/tts-service/modules ];
          };
          "tts-service-${index}-setup" = nixpkgs.lib.nixosSystem {
            pkgs = pkgs.x86_64-linux;
            specialArgs = serviceSpecialArgs;
            inherit modules;
          };
          "tts-service-${index}-initial" = nixpkgs.lib.nixosSystem {
            pkgs = pkgs.x86_64-linux;
            specialArgs = serviceSpecialArgs;
            modules = modules ++ [ ./common/users/gnome/ssh.nix ];
          };
        };
    in
    {
      packages = lib.mapAttrs (system: pkgs: {
        mach = pkgs.callPackage ./common/packages/mach.nix specialArgs;
        ff4d = pkgs.callPackage ./common/packages/ffmpeg4discord.nix specialArgs;
        azahar-bin = pkgs.callPackage ./common/packages/azahar-bin.nix specialArgs;
      }) pkgs;

      homeConfigurations.gnome = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs.aarch64-linux;
        modules = [ ./common/users/gnome/home.nix ];
      };

      darwinConfigurations.gnome = darwin.lib.darwinSystem {
        pkgs = pkgs.aarch64-darwin;
        inherit specialArgs;
        modules = [
          home-manager.darwinModules.home-manager
          ./configuration.darwin.nix

          ./common/modules/home-manager.nix

          ./common/users/gnome/general
          ./common/users/gnome/general/darwin.nix
          ./common/users/gnome/graphical.nix
        ];
      };

      nixosConfigurations = {
        gnome-desktop = nixpkgs.lib.nixosSystem {
          pkgs = pkgs.x86_64-linux;
          inherit specialArgs;
          modules = [
            ./configuration.nix

            ./common/modules/kde.nix
            ./common/modules/nvidia.nix
            ./common/modules/swapfile.nix
            ./common/modules/systemd-boot.nix
            ./common/modules/home-manager.nix
            ./common/modules/disable-sleep.nix

            ./common/users/gnome/general
            ./common/users/gnome/general/linux.nix
            ./common/users/gnome/graphical.nix
            ./common/users/gnome/kde.nix

            ./machines/gnome-desktop/modules/graphical.nix
            ./machines/gnome-desktop/modules/hardware-configuration.nix

            home-manager.nixosModules.home-manager
          ];
        };

        living-mac = nixpkgs.lib.nixosSystem {
          pkgs = pkgs.x86_64-linux;
          inherit specialArgs;
          modules = [
            ./configuration.nix

            ./common/modules/samba.nix
            ./common/modules/swapfile.nix
            ./common/modules/qbittorrent.nix
            ./common/modules/home-manager.nix
            ./common/modules/systemd-boot.nix
            ./common/modules/disable-sleep.nix
            ./common/modules/tailscale-server.nix

            ./common/users/gnome/general
            ./common/users/gnome/general/linux.nix

            ./common/users/fox/general.nix

            ./machines/living-mac/modules/immich.nix
            ./machines/living-mac/modules/t2fanrd.nix
            ./machines/living-mac/modules/firmware.nix
            ./machines/living-mac/modules/hardware-configuration.nix

            (import "${nixos-hardware pkgs.x86_64-linux}/apple/t2")
            home-manager.nixosModules.home-manager
            t2fanrd.nixosModules.t2fanrd
          ];
        };

        living-nuc = nixpkgs.lib.nixosSystem {
          pkgs = pkgs.x86_64-linux;
          inherit specialArgs;
          modules = [
            ./configuration.nix

            ./common/modules/samba.nix
            ./common/modules/swapfile.nix
            ./common/modules/qbittorrent.nix
            ./common/modules/home-manager.nix
            ./common/modules/systemd-boot.nix
            ./common/modules/disable-sleep.nix
            ./common/modules/tailscale-server.nix

            ./common/users/gnome/general
            ./common/users/gnome/general/linux.nix

            ./common/users/sleepy/general.nix

            ./machines/living-nuc/modules/kodi.nix
            ./machines/living-nuc/modules/firmware.nix
            ./machines/living-nuc/modules/home-assistant.nix
            ./machines/living-nuc/modules/hardware-configuration.nix

            home-manager.nixosModules.home-manager
            t2fanrd.nixosModules.t2fanrd
          ];
        };

        vm-aarch64-linux = nixpkgs.lib.nixosSystem {
          pkgs = pkgs.aarch64-linux;
          inherit specialArgs;
          modules = [
            ./configuration.nix

            ./common/modules/orbstack.nix

            ./common/users/gnome/general
            ./common/users/gnome/general/linux.nix

            home-manager.nixosModules.home-manager
          ];
        };
      }
      // mkTTSServices "1"
      // mkTTSServices "2";
    };
}
