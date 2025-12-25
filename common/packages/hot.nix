{ pkgs, lib, ... }:
let
  pname = "Hot";
  version = "1.9.4";
in
pkgs.stdenvNoCC.mkDerivation {
  inherit pname version;

  src = pkgs.fetchurl {
    url = "https://github.com/macmade/${pname}/releases/download/${version}/${pname}.zip";
    hash = "sha256-5PbM92Bmc+5hGHC/sdTMi+hqUIBY24+btc9B6ZftYco=";
  };

  unpackPhase = "${lib.getExe pkgs.unzip} $src";
  installPhase = ''
    mkdir -p $out/Applications
    cp -r ${pname}.app $out/Applications
  '';
}
