{
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:
let
  owner = "nathanmarlor";
  repo = "foxess_modbus";
  version = "1.13.6";
in
buildHomeAssistantComponent {
  inherit owner version;
  domain = repo;

  src = fetchFromGitHub {
    inherit owner repo;
    tag = "v${version}";
    hash = "sha256-cHF7hYB7I2Qxq41DeGoSnCy8CdxHetWol5m70cxq6xY";
  };
}
