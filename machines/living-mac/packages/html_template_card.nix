{
  stdenvNoCC,
  jninja2TemplateSrc,
}:
let
  filename = "html-template-card.js";
in
stdenvNoCC.mkDerivation {
  pname = "Home-Assistant-Lovelace-HTML-Jinja2-Template-card";
  version = jninja2TemplateSrc.shortRev;
  src = jninja2TemplateSrc;

  passthru.entrypoint = filename;
  installPhase = ''
    mkdir $out
    cp dist/${filename} $out
  '';
}
