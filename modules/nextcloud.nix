{ lib, pkgs, config, userName, ... }:
with lib;
let
  cfg = config.nc;
  occ = "nextcloud-occ";
  ensureKorvEnabledScript = pkgs.writeShellScript "ensure-korv-enabled" ''
    set -euo pipefail 
    korvenabled=$(${occ} user:info korv | grep enabled | tr -d '-' | tr -d ' ' | cut -d : -f 2)
    echo "User enabled: $korvenabled"
    if [ "$korvenabled" = "false" ]; then
      ${occ} user:enable korv && date
    else
      echo "User already enabled"
    fi
  '';


  #services.nextcloud.extraApps = { inherit (config.services.nextcloud.package.packages.apps) };
  /*files_share = pkgs.fetchNextcloudApp {
    name = "sharerenamer";
    sha256 = "74d46c22ed0f24a6fe00b2acf8e7f6a3a469ed00984ee035277c5ac9f605908e";
    license = "AGPL";
    url = "https://github.com/JonathanTreffler/sharerenamer/releases/download/v3.4.0/sharerenamer.tar.gz";
    version = "3.4.0";
  };*/
  /*sharerenamer = pkgs.fetchNextcloudApp {
    name = "sharerenamer";
    sha256 = "74d46c22ed0f24a6fe00b2acf8e7f6a3a469ed00984ee035277c5ac9f605908e";
    license = "AGPL";
    url = "https://github.com/JonathanTreffler/sharerenamer/releases/download/v3.4.0/sharerenamer.tar.gz";
    version = "3.4.0";
  };*/
  /*timemanager = pkgs.fetchNextcloudApp {
    name = "timemanager";
    sha256 = "a4594a3bc8c6239c1ab7df7ceaedc517065e4ca6401fbd4fa553306e5cdffec5";
    license = "AGPL";
    url = "https://github.com/te-online/timemanager/archive/refs/tags/v0.3.16.tar.gz";
    version = "0.3.16";
  };*/
in {

options.nc = {
  enable = mkEnableOption "";
  https  = mkOption {
    default = true;
    type = types.bool;
  };
  keepUserEnabled = mkEnableOption "Enable systemd service that reenables nc user";
  version = mkOption {
    default = "30";
    type = types.str;
  };
  hostName = mkOption {
    default = "127.0.0.1";
    type = types.str;
  };
  directory = mkOption {
    default = "/var/lib/nextcloud";
    type = types.str;
  };
  pwfile = mkOption {
    description = "Used during initial setup";
    default = "";
    type = types.str;
  };
  jellyfin = {
    enable = mkOption {
      default = true;
      type = types.bool;
    };
    hostName = mkOption {
      default = "tv.korv.lol";
      type = types.str;
    };
  };
};

config = mkIf cfg.enable (mkMerge [
  ({ # change listening port
    services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [{  addr = "127.0.0.1"; port = 8080; }];
  })
  ({ # nextcloud main
    services.nextcloud = {
      hostName = "moln.kevindybeck.com";
      home =  "/var/lib/nextcloud/5tb/nextcloud/" ;
      datadir = "/var/lib/nextcloud/5tb/nextcloud/"; 
      # configureRedis = true;
      /*secretFile = "path"; #{"redis":{"password":"secret"}}*/
      enable = true;
      https = false; #cfg.https; #HTTPS for generated links
      package = pkgs."nextcloud${cfg.version}";
      maxUploadSize = "16G";
      cli.memoryLimit = "2G";
      settings = {
        trusted_proxies = ["192.168.1.1" "*.kevindybeck.com"];	
        default_phone_region = "SE";
        loglevel = 1; 
        log_type = "syslog";
          overwriteprotocol = "https";
          overwritehost = "${config.services.nextcloud.hostName}";
          overwritewebroot = "/";
          overwrite.cli.url = "https://${config.services.nextcloud.hostName}/";
          htaccess.RewriteBase = "/";
        trusted_domains = [
          #services.nginx.virtualHosts."${config.services.nextcloud.hostName}".serverAliases;
          "192.168.*.*"
          "*.korv.lol" 
          "*.kevindybeck.com"
          "4.20.69.0" 
        ];
      };
      config = {
        adminuser = "admin"; # only in initial setup
        adminpassFile = cfg.pwfile;
      };
    };
    users.users."${userName}".extraGroups = [ "nextcloud" ];
  })
  ({ # db conf
    services.nextcloud.config = {
      dbtype = "mysql";
       # dbpassFile = ""; #via unix socket instead
    };
    services.mysql = {
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [{ 
        name = "nextcloud";   
        ensurePermissions = { "nextcloud.*" = "ALL PRIVILEGES";  }; 
      }];
    };
    services.mysqlBackup = {
      enable = true;
      databases = [ "nextcloud" ];
    };
  })
  ({ # nextcloud apps
    services.nextcloud = {
      appstoreEnable = true;
        /*
          Allow the installation and updating of apps from the Nextcloud appstore.
          Enabled by default unless there are packages in services.nextcloud.extraApps.
          Set this to true to force enable the store even if services.nextcloud.extraApps is used.
          Set this to false to disable the installation of apps from the global appstore.
          App management is always enabled regardless of this setting.
        */ 
      autoUpdateApps = { # auto-update of all apps installed from the Nextcloud app store
        enable = true;
        startAt = "05:00:00";
      };        
      extraAppsEnable = true; # autoenable extraApps every time Nextcloud starts 
      extraApps = { # Disables the appstore to prevent updating these apps (see .appstoreEnable)
        inherit (config.services.nextcloud.package.packages.apps)
        bookmarks
        calendar
        contacts
        cospend
        deck
        phonetrack
        tasks
      ;};
    };
  })
  ({ # media server
    services.jellyfin = {
      enable = true;
      group = "nextcloud";
    };
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
      jellycli
    ];
  })
  (mkIf cfg.keepUserEnabled {
    systemd.services.ensure-korv-enabled = {
      description = "Ensure Nextcloud user 'korv' is enabled";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${ensureKorvEnabledScript}";
        User = "nextcloud";
        Environment = "PATH=/run/current-system/sw/bin:/usr/bin:/bin";
      };
    };
    systemd.timers.ensure-korv-enabled = {
      description = "Run ensure-korv-enabled every 5 minutes";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5min";
        OnUnitActiveSec = "5min";
        Unit = "ensure-korv-enabled.service";
      };
    };
    environment.systemPackages = with pkgs; [ nextcloud-client ];
  })
]);}
