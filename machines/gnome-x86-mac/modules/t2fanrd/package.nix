{
  lib,
  fetchFromGitHub,
  rustPlatform,
  ...
}:

rustPlatform.buildRustPackage {
  pname = "t2fanrd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "GnomedDev";
    repo = "t2fanrd";
    rev = "85027878e4d7fa0170fea1213d6f8dd972d60e83";
    hash = "sha256-vOJAYbB/ZcRxM+/lrkab/PcON3vOz3o6eqPvM9hmaOw=";
  };

  cargoHash = "sha256-FKQYiaOTZxD95AWD2zbVjENzMAPrFl/rzhwbkAgGbx0=";
}
