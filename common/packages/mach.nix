{
  pkgs,
  rustPlatform,
  machSrc,
  ...
}:
rustPlatform.buildRustPackage {
  name = "mach";

  src = machSrc;
  cargoLock.lockFile = "${machSrc}/Cargo.lock";
  buildInputs = [ pkgs.boringssl ];
  nativeBuildInputs = with pkgs; [
    rustPlatform.bindgenHook
    cmake
    git
  ];
}
