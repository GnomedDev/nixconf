{ pkgs, wallpaperPath }:

pkgs.buildEnv {
  name = "plasma-desktop-with-sddm-theme";
  paths = [
    pkgs.kdePackages.plasma-desktop
    (pkgs.runCommandNoCC "sddm-theme" { } ''
      mkdir -p $out/share/sddm/themes/breeze/
      echo '[General] background=${wallpaperPath}' > $out/share/sddm/themes/breeze/theme.conf.user
    '')
  ];
}
