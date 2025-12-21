{
  fetchFromGitHub,
  fetchPnpmDeps,
  stdenvNoCC,
  pkgs,
}:
let
  owner = "flixlix";
  pname = "power-flow-card-plus";
  version = "0.2.6";

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    tag = "v${version}";
    hash = "sha256-qg4/7Xn4liZLjl2dwsC7vB8zmjWuHYW7ycuBewgDEfk=";
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = with pkgs; [
    pnpm
    nodejs
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    fetcherVersion = 2;
    hash = "sha256-1vfYwkvft8mYe+PVMmJslO1Y6628sG1a9oOzwx4aH+o=";
  };

  buildPhase = "pnpm run build";
  installPhase = ''
    mkdir $out
    cp dist/${pname}.js $out
  '';
}
