{ pkgs, ... }: {
  services.unifi = {
    enable = true;
    mongodbPackage = pkgs.mongodb-ce;
  };
}
