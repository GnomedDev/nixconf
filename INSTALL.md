# Install instructions

## TTS-service - Netcup

1. Create ARM machine on Netcup Cloud and mount NixOS ISO.
2. Connect to the machine via console and set a password.
3. Run the following script in the Live ISO via ssh:
```bash
sudo fdisk /dev/vda
sudo mkfs.ext4 /dev/vda1
sudo mkfs.fat -F 32 /dev/vda2

sudo mount /dev/vda1 /mnt
sudo mount --mkdir /dev/vda2 /mnt/boot
sudo nixos-install --no-root-passwd --flake github:GnomedDev/nixconf#tts-service-${N}-initial
```
4. Shutdown, unmount NixOS ISO and reboot.

## TTS-service - Contablo

1. Create VPS on Contablo and reboot into rescue system
2. Run the following in Live ISO via SSH:
```bash
curl -L https://github.com/nix-community/nixos-images/releases/latest/download/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz | tar -xzf- -C /root
/root/kexec/run

sudo fdisk /dev/sda (
    o
    n, p, 1, <default>, <default>
    w
)

sudo mkfs.ext4 /dev/sda1
sudo mount /dev/sda1 /mnt
sudo nixos-install --no-root-passwd --flake github:GnomedDev/nixconf#tts-service-${N}-initial
```
3. Shutdown the server, and it should be automatically rebooted.

## TTS-service continued:

1. Login to server with SSH as root user, shouldn't need password.
2. Log into Tailscale, provision with `tts-service` tag, and `tailscale up --ssh`.
3. Swap to Tailscale-based SSH with:
```bash
sudo nixos-rebuild switch --flake github:GnomedDev/nixconf#tts-service-${N}-setup
```
4. Provision secrets and env files based on `machines/tts-service/modules/default.nix`.
5. Start up the final machine with:
```bash
sudo nixos-rebuild switch --flake github:GnomedDev/nixconf#tts-service-${N}
```
