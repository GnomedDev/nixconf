{ ... }:
{
  services.beesd.filesystems.ext-hdd = {
    spec = "/mnt/ext-hdd";
    hashTableSizeMB = 16384;
    extraOptions = [
      "--loadavg-target"
      "4.0"
    ];
  };
}
