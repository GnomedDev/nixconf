{ pkgs, lib, ... }:
let
  pname = "azahar";
  version = pkgs.azahar.version;
in
pkgs.stdenvNoCC.mkDerivation {
  inherit pname version;

  src = pkgs.fetchurl {
    url = "https://github.com/azahar-emu/azahar/releases/download/${version}/azahar-${version}-macos-arm64.zip";
    sha256 = "1fc823cdcae00c9f3aeda7c19c1a990b2bebd0f9e03328d3f74b38b6c4cb23f7";
  };

  unpackPhase = "${lib.getExe pkgs.unzip} $src";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r azahar-${version}-macos-arm64/Azahar.app $out/Applications
  '';
}
