{ pkgs, ... }:

let
  t2fanrd = pkgs.callPackage ./package.nix { };
in
{
  environment.systemPackages = [
    t2fanrd
  ];

  systemd.services.t2fanrd = {
    enable = true;

    description = "T2FanRD daemon to manage fan curves for t2 macs";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "exec";
      Restart = "always";
      ExecStart = "${t2fanrd}/bin/t2fanrd";

      PrivateTmp = "true";
      ProtectSystem = "true";
      ProtectHome = "true";
      ProtectClock = "true";
      ProtectControlGroups = "true";
      ProtectHostname = "true";
      ProtectKernelLogs = "true";
      ProtectKernelModules = "true";
      ProtectProc = "invisible";
      PrivateDevices = "true";
      PrivateNetwork = "true";
      NoNewPrivileges = "true";
      DevicePolicy = "closed";
      KeyringMode = "private";
      LockPersonality = "true";
      MemoryDenyWriteExecute = "true";
      PrivateUsers = "yes";
      RemoveIPC = "yes";
      RestrictNamespaces = "yes";
      RestrictRealtime = "yes";
      RestrictSUIDSGID = "yes";
      SystemCallArchitectures = "native";
    };
  };
}
