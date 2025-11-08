{
  pkgs,
  python3Packages,
  fetchPypi,
  ...
}:
let
  pname = "ffmpeg4discord";
  version = "0.1.9";
in
python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6JUKnsqQRMh2tIgAHho7IAFBO3scE22QNy8zVVxaOXo=";
  };

  pythonRelaxDeps = [ "flask" ];
  buildInputs = with pkgs; [ ffmpeg ];
  nativeBuildInputs = with python3Packages; [ pythonRelaxDepsHook ];

  build-system = with python3Packages; [ setuptools ];
  dependencies = with python3Packages; [
    flask
    ffmpeg-python
  ];
}
