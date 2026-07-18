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
    sha256 = "sha256-vsDiikWSsHPsKFUQk1wkNTva4ou0Q5YdRBq3aNZv/aw=";
  };

  unpackPhase = "${lib.getExe pkgs.unzip} $src";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r ${srcName}/Azahar.app $out/Applications
  '';
}
