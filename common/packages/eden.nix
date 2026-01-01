{
  lib,
  pkgs,
  stdenv,

  edenSrc,
  mclSrc,
  siritSrc,
  oaknutSrc,
  ...
}:
stdenv.mkDerivation {
  name = "eden";
  src = edenSrc;

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];
  buildInputs =
    with pkgs;
    [
      fmt
      lz4
      zlib
      zstd
      SDL2
      enet
      boost
      cubeb
      ffmpeg
      libusb1
      libopus
      openssl
      mbedtls
      httplib
      cpp-jwt
      glslang
      simpleini
      gitMinimal
      spirv-tools
      spirv-headers
      nlohmann_json
      vulkan-headers
      unordered_dense
      frozen-containers
      vulkan-memory-allocator
      vulkan-utility-libraries

      qt6.qtbase
      qt6.qttools
      qt6.qt5compat
      qt6.qtwebengine
      qt6.qtmultimedia
      qt6Packages.quazip

      (stdenv.mkDerivation {
        name = "eden-sirit";
        src = siritSrc;

        cmakeFlags = [ "-DSIRIT_USE_SYSTEM_SPIRV_HEADERS=ON" ];

        nativeBuildInputs = [ cmake ];
        buildInputs = [ spirv-headers ];
      })
      (stdenv.mkDerivation {
        name = "eden-oaknut";
        src = oaknutSrc;

        nativeBuildInputs = [ cmake ];
      })
      (stdenv.mkDerivation {
        name = "eden-mcl";
        src = mclSrc;

        nativeBuildInputs = [ cmake ];
        buildInputs = [ fmt ];
      })
    ]
    ++ lib.optionals stdenv.isDarwin [
      llvmPackages_20.libcxx
      darwin.bootstrap_cmds
      moltenvk
      libintl
    ];

  # Patch out references to gamemode.
  postPatch = ''
    substituteInPlace ./CMakeLists.txt --replace-fail "find_package(gamemode)" ""
    substituteInPlace ./externals/CMakeLists.txt --replace-fail "AddJsonPackage(gamemode)" ""
    substituteInPlace ./src/qt_common/CMakeLists.txt \
        --replace-fail "target_link_libraries(qt_common PRIVATE gamemode::headers)" "" \
        --replace-fail "gamemode.cpp" "" \
        --replace-fail "gamemode.h" ""
    substituteInPlace ./src/yuzu/main_window.cpp \
        --replace-fail "Common::FeralGamemode::Start()" "" \
        --replace-fail "Common::FeralGamemode::Stop()" ""
  '';

  cmakeFlags =
    let
      tzdbVer = "121125";
      tzdbToNX = pkgs.fetchzip {
        url = "https://git.crueter.xyz/misc/tzdb_to_nx/releases/download/${tzdbVer}/${tzdbVer}.tar.gz";
        hash = "sha256-6+qt4yzisNx8cAOrWVS+g/GCeTD37iejQN06Ij6OMxU=";
      };
    in
    [
      "-DYUZU_TZDB_PATH=${tzdbToNX}"
      "-DYUZU_USE_BUNDLED_MOLTENVK=NO"
    ];

  installPhase = ''
    mkdir $out
    cp -r bin $out
    cp -r dist $out

    mkdir $out/Applications
    mv $out/bin/eden.app $out/Applications
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath ${pkgs.moltenvk}/lib $out/Applications/eden.app/Contents/MacOS/eden
  '';
}
