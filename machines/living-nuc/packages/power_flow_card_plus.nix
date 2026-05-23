{
  powerFlowCardSrc,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "power-flow-card-plus";
  version = powerFlowCardSrc.shortRev;
  src = powerFlowCardSrc;

  installPhase = ''
    mkdir $out
    cp power-flow-card-plus.js $out
  '';
}
