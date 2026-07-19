# Install instructions

## TTS-service

1. Create ARM machine on Netcup Cloud.
2. Connect to the machine via console and set a password.
3. Run the following in Live ISO via SSH:
```bash
curl -L https://github.com/nix-community/nixos-images/releases/latest/download/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz | tar -xzf- -C /root
/root/kexec/run

sudo fdisk /dev/vda
sudo mkfs.ext4 /dev/vda1

sudo mount /dev/vda1 /mnt
sudo mount --mkdir /dev/vda2 /mnt/boot
sudo nixos-install --no-root-passwd --flake github:GnomedDev/nixconf#tts-service-${N}-initial
```
4. Reboot.
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
