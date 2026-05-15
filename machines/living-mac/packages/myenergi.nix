{
  buildHomeAssistantComponent,
  home-assistant,
  myEnergiSrc,
}:

buildHomeAssistantComponent {
  owner = "CJNE";
  domain = "myenergi";
  version = myEnergiSrc.shortRev;

  src = myEnergiSrc;
  dependencies = [
    (
      let
        pname = "pymyenergi";
        version = "0.2.3";
        python3Packages = home-assistant.python.pkgs;
      in
      python3Packages.buildPythonPackage {
        inherit pname version;
        pyproject = true;

        postPatch = ''
          substituteInPlace setup.py --replace-fail 'setup_requires=("pytest-runner"),' ""
        '';

        build-system = [ python3Packages.setuptools ];
        src = python3Packages.fetchPypi {
          inherit pname version;
          hash = "sha256-iulRWV9179+7CwAwvDWHXZGTQkDF/P+0paBCDsUBbUE=";
        };
        dependencies = with python3Packages; [
          httpx
          pycognito
        ];
      }
    )
  ];
}
