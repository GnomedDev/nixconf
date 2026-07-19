{
  inputs = {
    nixpkgs-unpatched.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware-unpatched.url = "github:NixOS/nixos-hardware";
    nixos-hardware-unpatched.inputs.nixpkgs.follows = "nixpkgs-unpatched";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unpatched";

    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unpatched";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs-unpatched";

    t2fanrd.url = "github:GnomedDev/t2fanrd/feat/min-max-override";
    t2fanrd.inputs.nixpkgs.follows = "nixpkgs-unpatched";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs-unpatched";
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
      nixpkgs-unpatched,
      nixos-hardware-unpatched,
      darwin,
      home-manager,
      t2fanrd,
      ...
    }@inputs:

    let
      lib = nixpkgs-unpatched.lib;
      nixpkgs = lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (
        system:
        let
          pkgs = import nixpkgs-unpatched { inherit system; };
        in
        pkgs.applyPatches {
          name = "nixpkgs-patched";
          src = nixpkgs-unpatched;
          patches = [
            (pkgs.fetchpatch2 {
              url = "https://github.com/NixOS/nixpkgs/pull/542528.patch";
              hash = "sha256-KxVYvPJcC4nkUSoNz06hECxzj8Fvbh4uS5CQRooqe2s=";
            })
          ];
        }
      );

      pkgs = lib.mapAttrs (
        system: nixpkgs:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        }
      ) nixpkgs;

      nixos-hardware = lib.mapAttrs (
        system: pkgs:
        pkgs.applyPatches {
          name = "nixos-hardware-patched";
          src = nixos-hardware-unpatched;
          patches = [
            (pkgs.fetchpatch2 {
              url = "https://github.com/NixOS/nixos-hardware/pull/1934.patch";
              hash = "sha256-A0YQUcXPEfZJ5Z5RjRoIgDZyaWY2xZxutB1RJLftaQA=";
            })
            (pkgs.fetchpatch2 {
              url ="https://github.com/NixOS/nixos-hardware/pull/1933.patch";
              hash = "sha256-/dD+9rMdilJko+TrKqzjVOpizEXG3l69xMFYI/dJaUA=";
            })
          ];
        }
      ) pkgs;

      specialArgs = inputs;
      mkTTSServices =
        index: ipBlock:
        let
          servicePkgs = pkgs.aarch64-linux;
          serviceSpecialArgs = specialArgs // {
            inherit ipBlock;
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
          "tts-service-${index}" = lib.nixosSystem {
            pkgs = servicePkgs;
            specialArgs = serviceSpecialArgs;
            modules = modules ++ [ ./machines/tts-service/modules ];
          };
          "tts-service-${index}-setup" = lib.nixosSystem {
            pkgs = servicePkgs;
            specialArgs = serviceSpecialArgs;
            inherit modules;
          };
          "tts-service-${index}-initial" = lib.nixosSystem {
            pkgs = servicePkgs;
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
        gnome-desktop = lib.nixosSystem {
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

        living-mac = lib.nixosSystem {
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

            (import "${nixos-hardware.x86_64-linux}/apple/t2")
            home-manager.nixosModules.home-manager
            t2fanrd.nixosModules.t2fanrd
          ];
        };

        living-nuc = lib.nixosSystem {
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

        vm-aarch64-linux = lib.nixosSystem {
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
      // mkTTSServices "1" "2a03:4000:65:cbe::"
      // mkTTSServices "2" "2a03:4000:65:ce3::"
      // mkTTSServices "3" "2a03:4000:65:e46::"
      // mkTTSServices "4" "2a03:4000:65:525::";
    };
}
