{ lib, pkgs, config, ... }:
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
  email = mkOption {
    default = "";
    type = types.str;
  };
  pwfile = mkOption {
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
  ({
    services.nextcloud = {
      # configureRedis = true;
      /*secretFile = "path"; #{"redis":{"password":"secret"}}*/

      hostName = cfg.hostName;
      home = cfg.directory; 
      enable = true;
      https = cfg.https; #HTTPS for generated links
      nginx.recommendedHttpHeaders = true;
      package = pkgs."nextcloud${cfg.version}";
      maxUploadSize = "16G";
      cli.memoryLimit = "2G";
      settings = {
        trusted_domains = ["192.168.1.12"];
        trusted_proxies = ["192.168.1.1"];	
        default_phone_region = "SE";
        # skeletondirectory "";
        loglevel = 1; # [0:debug, 1:info, [2]:warn, 3:error, 4:fatal]
        log_type = "syslog"; #"errorlog", ["syslog"], "systemd", "file"
      };
      config = {
        dbtype = "mysql";
         # dbpassFile = "/pw/pw"; #via unix socket instead
        adminuser = "admin"; # only in initial setup
        adminpassFile = cfg.pwfile; # only in initial setup 
      };
      phpOptions = {
        catch_workers_output = "yes"; # def
        display_errors = "stderr"; # def
        error_reporting = "E_ALL & ~E_DEPRECATED & ~E_STRICT"; # def
        expose_php = "Off"; # def
        output_buffering = "0"; # def
        short_open_tag = "Off"; # def
        #"openssl.cafile" = "/etc/ssl/certs/ca-certificates.crt";
        #instanceid = "ocvufs9qxu02";
        #passwordsalt = "XDtrXybh8uBcOgIATWsJ7zV+h07pHt";
        #secret = "Uf6KwmcYdtW1WkvlvNrOaoLdvhH8EDsPZWnG66/ALHU17fAO";
        #mysqlutf8mb' =" tru";
        #installed = "ru";
        #default_locale = "sv_SE";
        #twofactor_enforced = "false";
        #"bulkupload.enabled" = "false";
        #"htaccess.RewriteBase" = "/";
        #theme = "";
        "opcache.fast_shutdown" = "1"; # def
        "opcache.interned_strings_buffer" = "16"; # def: "8"
        "opcache.max_accelerated_files" = "10000"; # def
        "opcache.memory_consumption" = "128"; # def
        "opcache.revalidate_freq" = "1"; # def
      };
    };

    services.mysql = {
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [{ 
        name = "nextcloud";   
        ensurePermissions = { "nextcloud.*" = "ALL PRIVILEGES";  }; 
      }];
    };
    services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = cfg.https;
      enableACME = cfg.https;
      locations."/tv".proxyPass = "http://127.0.0.1:8096";
      /*locations."/bio".return = "302 $scheme://$host/bio/";*/
      /*locations."/bio/".proxyPass = "https://127.0.0.1:8920";*/
    };
    environment.etc."ncversion".text = "nextcloud${cfg.version}";
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
  (mkIf cfg.jellyfin.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
      user = "nextcloud";
      group = "nextcloud";
      dataDir = "/var/lib/nextcloud/5tb/nextcloud/data/korv/files/videofiles/";
      configDir = "/var/lib/jellyfin/config";
    };
    services.nginx.virtualHosts.${cfg.jellyfin.hostName} = {
      forceSSL = cfg.https;
      enableACME = cfg.https;
      locations."/".proxyPass = "http://127.0.0.1:8096"; #http
      /*locations."/".proxyPass = "https://127.0.0.1:8920"; #https*/
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
  ({ 
    security.acme.defaults = {
      email = cfg.email;
      webroot = "/var/lib/acme/acme-challenge";
    };
    security.acme.acceptTerms = true;
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };
    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 80 443 ];
    };
  })
]);}
