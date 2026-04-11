# Install instructions

## TTS-service

1. Create machine on Hetzner Cloud and mount NixOS ISO.
2. Connect to the machine via console and set a password.
3. Run the following script in the Live ISO via ssh:
```bash
sudo mkfs.ext4 /dev/sda1

sudo mount /dev/sda1 /mnt
sudo mount --mkdir /dev/sda15 /mnt/boot
sudo nixos-install --no-root-passwd --flake github:GnomedDev/nixconf#tts-service-${N}-initial
```
4. Shutdown, unmount NixOS ISO and reboot.
5. Login to server with SSH as root user, shouldn't need password.
6. Log into Tailscale, provision with `tts-service` tag, and `tailscale up --ssh`.
7. Swap to Tailscale-based SSH with:
```bash
sudo nixos-rebuild switch --flake github:GnomedDev/nixconf#tts-service-${N}-setup
```
8. Provision secrets and env files based on `machines/tts-service/modules/default.nix`.
9. Start up the final machine with:
```bash
sudo nixos-rebuild switch --flake github:GnomedDev/nixconf#tts-service-${N}
```
