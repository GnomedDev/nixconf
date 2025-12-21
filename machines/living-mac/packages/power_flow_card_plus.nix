{
  powerFlowCardSrc,
  fetchPnpmDeps,
  stdenvNoCC,
  pkgs,
}:
let
  pname = "power-flow-card-plus";
  version = "0.2.6";
in
stdenvNoCC.mkDerivation {
  inherit pname;
  src = powerFlowCardSrc;

  nativeBuildInputs = with pkgs; [
    pnpm
    nodejs
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit pname version;
    src = powerFlowCardSrc;
    fetcherVersion = 2;
    hash = "sha256-1vfYwkvft8mYe+PVMmJslO1Y6628sG1a9oOzwx4aH+o=";
  };

  buildPhase = "pnpm run build";
  installPhase = ''
    mkdir $out
    cp dist/${pname}.js $out
  '';
}
