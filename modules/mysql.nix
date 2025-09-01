{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mysql;
in
{
  options.mysql.enable = mkEnableOption "";

  config = (mkMerge [
    ( mkIf cfg.enable {
      services.mysql.enable = true;
    })
    ({
      services.mysql = { 
        package = pkgs.mariadb;
        ensureUsers = [
          { name = "root";        ensurePermissions = { "root.*" = "ALL PRIVILEGES"; }; }
          { name = "mysqlbackup"; ensurePermissions = { "*.*" = "SELECT, LOCK TABLES"; }; }
        ];
      };
    })
  ]);
  /* # default values
    services.mysql.dataDir = "/var/lib/mysql";
    services.mysql.initialScript = /etc/db.dump;
    services.mysqlBackup.location = "/var/backup/mysql";
    services.mysqlBackup.user ="mysqlbackup"
    services.mysqlBackup.calendar = "01:15:00";
    services.mysqlBackup.gzipOptions = "--no-name --rsyncable";
    services.mysqlBackup.compressionAlg = "gzip";
    services.mysqlBackup.compressionLevel = null; #gzip:1-9, xz:0-9, zstd:1-19
    services.mysqlBackup.singleTransaction = false;
  */
}
