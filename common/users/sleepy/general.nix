{ ... }:
{
  users.users.sleepy = {
    isNormalUser = true;
    home = "/home/sleepy";

    # Enable ‘sudo’ for the user.
    extraGroups = [ "wheel" ];
  };
}
