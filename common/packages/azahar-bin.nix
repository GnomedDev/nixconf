{ pkgs, lib, ... }:
let
  pname = "azahar";
  version = pkgs.azahar.version;
  srcName = "azahar-macos-arm64-${version}";
in
pkgs.stdenvNoCC.mkDerivation {
  inherit pname version;

  src = pkgs.fetchurl {
    url = "https://github.com/azahar-emu/azahar/releases/download/${version}/${srcName}.zip";
    sha256 = "sha256-wk3sK9URG315UT1obFrs5mEs2/lzey5uqZz8Qm8dSu8=";
  };

  unpackPhase = "${lib.getExe pkgs.unzip} $src";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r ${srcName}/Azahar.app $out/Applications
  '';
}
