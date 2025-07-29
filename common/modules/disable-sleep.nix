{ ... }:

{
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
  '';
}
