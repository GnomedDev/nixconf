{
  powerFlowCardSrc,
  fetchPnpmDeps,
  stdenvNoCC,
  pkgs,
}:
let
  pname = "power-flow-card-plus";
  version = powerFlowCardSrc.shortRev;
in
stdenvNoCC.mkDerivation {
  inherit pname version;
  src = "${powerFlowCardSrc}";

  nativeBuildInputs = with pkgs; [
    pnpm
    nodejs
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit pname version;
    src = powerFlowCardSrc;
    fetcherVersion = 2;
    hash = "sha256-AXaf1gQYzCZ34ERpDhdAOVc4HLAWdO0LRE80f6zSkxw=";
  };

  buildPhase = ''
    pushd packages/flixlix-cards/power-flow-card-plus
    pnpm run build
    popd
  '';
  installPhase = ''
    mkdir $out
    cp dist/${pname}.js $out
  '';
}
