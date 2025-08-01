{ ... }:

{
  networking.hostName = "living-pi";
  networking.networkmanager = {
    enable = true;
    unmanaged = [ "type:wifi" ];
  };
}
