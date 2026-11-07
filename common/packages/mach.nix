{
  rustPlatform,
  machSrc,
  boringssl,
  aws-lc,
  lib,
  stdenv,
  ...
}:
rustPlatform.buildRustPackage {
  name = "mach";

  src = machSrc;
  cargoLock.lockFile = "${machSrc}/Cargo.lock";

  postPatch = ''
    substituteInPlace $cargoDepsCopy/boring-sys-*/build/main.rs \
      --replace-fail "cargo:rustc-link-lib=static" "cargo:rustc-link-lib=dylib"
  '';

  env = {
    BORING_BSSL_PATH = boringssl;
    BORING_BSSL_INCLUDE_PATH = "${boringssl.dev}/include";
  };

  buildInputs = [ aws-lc ];
  nativeBuildInputs = lib.optional stdenv.targetPlatform.isLinux rustPlatform.bindgenHook;
}
