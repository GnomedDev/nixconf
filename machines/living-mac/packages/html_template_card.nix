{
  stdenvNoCC,
  jninja2TemplateSrc,
}:
stdenvNoCC.mkDerivation {
  pname = "Home-Assistant-Lovelace-HTML-Jinja2-Template-card";

  src = jninja2TemplateSrc;

  installPhase = ''
    mkdir $out
    cp dist/html-template-card.js $out
  '';
}
