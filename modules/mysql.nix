{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mysql;
in
{
  options.mysql.enable = mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.mysql.enable = true;
    services.mysql.package = pkgs.mariadb;
    #services.mysql.dataDir = "/var/lib/mysql";
    #services.mysql.initialScript = /etc/db.dump;
    services.mysql.ensureUsers = [
      { name = "root";        ensurePermissions = { "root.*" = "ALL PRIVILEGES"; }; }
      { name = "mysqlbackup"; ensurePermissions = { "*.*" = "SELECT, LOCK TABLES"; }; }
    ];

    services.mysqlBackup = {
      enable = true;
      databases = [ "nextcloud" ];
      #location = "/var/backup/mysql";
      #user ="mysqlbackup"
      #calendar = "01:15:00";
      #gzipOptions = "--no-name --rsyncable";
      #compressionAlg = "gzip";
      #compressionLevel = null; #gzip:1-9, xz:0-9, zstd:1-19
      #singleTransaction = false;
    };
  };

}
