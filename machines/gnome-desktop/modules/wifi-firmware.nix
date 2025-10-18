{...}: {
  boot.extraModulePackages = with config.boot.kernelPackages; [ rtw89 ];
}