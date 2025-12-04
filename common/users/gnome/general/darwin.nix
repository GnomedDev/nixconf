{ ... }:
{
  system.primaryUser = "gnome";
  users.users.gnome = {
    uid = 501;
    home = "/Users/gnome";
  };
}
