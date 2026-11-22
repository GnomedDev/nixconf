{ lib, system }:
lib.optionals (system == "aarch64-darwin") [
  (finalPkgs: prevPkgs: {
    comma = prevPkgs.comma.overrideAttrs (
      final: prev: {
        nativeBuildInputs = prev.nativeBuildInputs ++ [ finalPkgs.makeBinaryWrapper ];

        postPatch = "";
        postInstall = ''
          ${prev.postInstall}
          wrapProgram $out/bin/comma --prefix PATH : ${finalPkgs.fzy}/bin
        '';
      }
    );
    nixos-rebuild-ng = prevPkgs.nixos-rebuild-ng.overrideAttrs (
      final: prev: {
        propagatedBuildInputs = [ ];
      }
    );
  })
]
