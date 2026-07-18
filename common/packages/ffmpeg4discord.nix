{
  pkgs,
  python3Packages,
  fetchPypi,
  ...
}:
let
  pname = "ffmpeg4discord";
  version = "0.2.2";
in
python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cRn7ucm5AyEUWuZPYvj7TsiCN62WVDhlcaMzZ6TRry8=";
  };

  pythonRelaxDeps = [ "flask" ];
  buildInputs = with pkgs; [ ffmpeg ];
  nativeBuildInputs = with python3Packages; [ pythonRelaxDepsHook ];

  build-system = with python3Packages; [ setuptools ];
  dependencies = with python3Packages; [
    flask
    platformdirs
    ffmpeg-python
  ];
}
