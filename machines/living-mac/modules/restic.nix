{ ... }: {
  services.restic.backups.living-nuc = {
    initialize = true;
    repositoryFile = "/var/certs/restic-repo-file";
    passwordFile = "/var/certs/restic-repo-passwd";
    paths = [
      "/srv/share/Daisy"
      "/srv/share/Fox"
      "/srv/share/Jax"
      "/srv/share/Photos"
      "/var/lib/postgresql"
      "/var/lib/qBittorrent"
      "/var/lib/nextcloud"
      "/var/lib/unifi"
    ];
  };
}
