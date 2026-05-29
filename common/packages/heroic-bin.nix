{ pkgs, lib, ... }:
let
  pname = "Heroic";
  version = pkgs.heroic.version;
  srcName = "Heroic-${version}-macOS-arm64";
in
pkgs.stdenvNoCC.mkDerivation {
  inherit pname version;

  src = pkgs.fetchurl {
    url = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v${version}/${srcName}.zip";
    sha256 = "sha256-IpgXKVuxDztPy3N3CKZ56wlRx8g6gLY9i+lKLVEwsaw=";
  };

  unpackPhase = "${lib.getExe pkgs.unzip} $src";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r Heroic.app $out/Applications
  '';
}
