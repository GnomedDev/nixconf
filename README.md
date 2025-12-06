# NixConf

My Nix config for my machines running NixOS.

This is public for troubleshooting or as an example for others.

## Machines

### gnome-desktop

A self-built gaming PC, with an AMD processor and NVIDIA GPU using an out-of-tree rtw89 driver for WIFI.

### living-mac

A 2020 Macbook Air with 8GB of ram used as a server, requires special firmware (see `wifi-firmware`) and daemons (see `t2fanrd`).

This runs Samba, Home Assistant, Predbat, and other software you'd find on a home server.

### darwinConfigurations.gnome

An M2 Macbook Pro with 16GB of ram running MacOS and being managed with nix-darwin.
