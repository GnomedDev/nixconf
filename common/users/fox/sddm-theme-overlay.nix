final: prev: let wallpaperPath = "${final.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png"; in ;{
  kdePackages = prev.kdePackages.overrideScope (
    kdeFinal: kdePrev: {
      plasma-desktop = pkgs.buildEnv {
        name = "plasma-desktop-with-sddm-theme";
        paths = [
          pkgs.kdePackages.plasma-desktop
          (pkgs.runCommandNoCC "sddm-theme" { } ''
            mkdir -p $out/share/sddm/themes/breeze/
            echo '[General] background=${wallpaperPath}' > $out/share/sddm/themes/breeze/theme.conf.user
          '')
        ];
      };
    }
  );
}
