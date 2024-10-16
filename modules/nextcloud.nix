{ lib, pkgs, config, ... }:
with lib;
let cfg = config.nc;
in
{
  options.nc.enable = mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.nextcloud = {
      enable = true;
      maxUploadSize = "";

      https = true;
      hostName = "";
      home = "";
      extraApps = { };
      datadir = "";
      appstoreEnable = true;

services.nextcloud.settings.trusted_domains
services.nextcloud.settings.trusted_domains
services.nextcloud.settings.skeletondirectory
services.nextcloud.configureRedis
    services.nextcloud.config.dbuser

    services.nextcloud.config.dbtype

    services.nextcloud.config.dbtableprefix

    services.nextcloud.config.dbpassFile

