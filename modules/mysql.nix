{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mysql;
in
{
  options.mysql.enable = mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.mysql.enable = true;
    services.mysql.package = pkgs.mariadb;
    #services.mysql.initialScript = /etc/db.dump;
    services.mysql.ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions = {
          "nextcloud.*" = "ALL PRIVILEGES";
        };
      }
      {
        name = "root";
        ensurePermissions = {
          "root.*" = "ALL PRIVILEGES";
        };
      }
      {
        name = "backup";
        ensurePermissions = {
          "*.*" = "SELECT, LOCK TABLES";
        };
      }
    ];
  };

}