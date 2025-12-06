{
  fetchFromGitHub,
  stdenvNoCC,
  pkgs,
}:
let
  pname = "Home-Assistant-Lovelace-HTML-Jinja2-Template-card";
  version = "1.0.2";
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-xmPDwj6FicMAehsRaXnXUiJgWlESTtR2P0qYEt9T+fU=";
  };

  installPhase = ''
    mkdir $out
    cp dist/html-template-card.js $out
  '';
}
