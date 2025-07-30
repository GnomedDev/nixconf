{ home, ... }:

{
  home-manager.users.gnome =
    { ... }:
    {
      programs.git = {
        enable = true;
        userName = "GnomedDev";
        userEmail = "daisy2005thomas@gmail.com";

        signing = {
          signByDefault = true;

          format = "ssh";
          key = "/home/gnome/.ssh/id_rsa";
        };

        extraConfig.push.autoSetupRemote = "true";
      };
    };
}
