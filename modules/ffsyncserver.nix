{ lib, pkgs, config, ... } :
with lib;
let cfg = config.ffsyncserver;
in {
  options.ffsyncserver = {
    enable = mkEnableOption "custom ffsyncserver conf";
  };

  config = mkIf cfg.enable {
    services.mysql.package = pkgs.mariadb;
    services.firefox-syncserver = {
      enable = true;
      secrets = builtins.toFile "sync-secrets" ''
        SYNC_MASTER_SECRET=this-secret-is-actually-leaked-to-/nix/store
        '';
      singleNode = {
        enable = true;
        hostname = "localhost";
        url = "http://localhost:5000";
      };
    };
  };
}