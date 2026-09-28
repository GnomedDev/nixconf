{ ... }: {
  services.restic.server = {
    enable = true;
    dataDir = "/mnt/ext-hdd/restic";
  };
}
