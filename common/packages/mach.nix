{
  pkgs,
  rustPlatform,
  machSrc,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "mach";
  version = "3.3.0";

  src = machSrc;
  cargoLock.lockFile = "${machSrc}/Cargo.lock";
  buildInputs = [ pkgs.boringssl ];
  nativeBuildInputs = with pkgs; [
    rustPlatform.bindgenHook
    cmake
    git
  ];
}
