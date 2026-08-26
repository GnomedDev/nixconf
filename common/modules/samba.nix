{ sharePath, ... }:
{
  # Remember to run `sudo smbpasswd -sa {user}` to set up passwords!
  services.samba = {
    enable = true;
    smbd.enable = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";

        # Only use the latest SMB3 protocol for security
        "server min protocol" = "SMB3_11";
        # Configure as running on it's own, not as a part of an MS network
        "server role" = "standalone server";

        # Put the logs on the hard drive, in the `logs` folder.
        "log file" = "${sharePath}/logs/samba/log.%m";
        "max log size" = "1000";
        logging = "file";

        # Unsucessful logins just get kicked off.
        "map to guest" = "bad user";
      };

      "External HDD" = {
        path = sharePath;
        "read only" = false;
        browsable = "yes";

        # Force all new folders/files to be created with read/write permissions for all users.
        "force create mode" = 777;
        "force directory mode" = 777;
      };
    };
  };
}
