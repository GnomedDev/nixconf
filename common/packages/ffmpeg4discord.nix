{
  pkgs,
  python3Packages,
  fetchPypi,
  ...
}:
let
  pname = "ffmpeg4discord";
  version = "0.2.3";
in
python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KwBl+VEZfz7OyJ+tnu4zDR+1Lct55ujvtC0yNCuT6wc=";
  };

  pythonRelaxDeps = [ "flask" ];
  buildInputs = with pkgs; [ ffmpeg_8 ]; # zfleeman/ffmpeg4discord#6666
  nativeBuildInputs = with python3Packages; [ pythonRelaxDepsHook ];

  build-system = with python3Packages; [ setuptools ];
  dependencies = with python3Packages; [
    flask
    platformdirs
    ffmpeg-python
  ];
}
