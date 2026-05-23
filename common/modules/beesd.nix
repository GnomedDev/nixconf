{ ... }:
{
  services.beesd.filesystems.ext-hdd = {
    spec = "/mnt/ext-hdd";
    hashTableSizeMB = 512;
    extraOptions = [
      "--loadavg-target"
      "4.0"
    ];
  };
}
