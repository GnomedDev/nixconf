{
  pkgs,
  rustPlatform,
  fetchFromGitHub,
  ...
}:
let
  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "networkquality-rs";
    rev = "d3cfd772f4c14790944b7aabe8c8ef24a7c5a846";
    hash = "sha256-qMs7HiHVoL8yXale/1fQm53svB/YCu47zNJZv/ht7rw=";
  };
in
rustPlatform.buildRustPackage {
  pname = "mach";
  version = "3.3.0";

  inherit src;
  cargoLock.lockFile = "${src}/Cargo.lock";
  buildInputs = [ pkgs.boringssl ];
  nativeBuildInputs = with pkgs; [
    rustPlatform.bindgenHook
    cmake
    git
  ];
}
