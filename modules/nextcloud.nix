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
in
{
  options.nc = {
    enable = mkEnableOption "";
    version = mkOption {
      default = "31";
      type = types.str;
    };
    email = mkOption {
      default = "kevin.dybeck@yahoo.com";
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
        default = "tv.korv.lol" ;#"bio.kevindybeck.com";
        type = types.str;
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    /*(mkIf {})*/
    ({
      services.nextcloud.settings.trusted_domains = [ "100.84.203.89" ];
    })
    ({
      services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      };
      services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
        #forceSSL = true;
        #enableACME = true;
        /*locations."/".proxyPass = "http://127.0.0.1:8920";*/
        /*locations."/bio".return = "302 $scheme://$host/bio/";*/
        /*locations."/bio/".proxyPass = "https://127.0.0.1:8920";*/
      };
      services.nginx.virtualHosts.${cfg.jellyfin.hostName} = mkIf cfg.jellyfin.enable {
        #forceSSL = true;
        #enableACME = true;
        locations."/".proxyPass = "http://127.0.0.1:8096"; #http
        /*locations."/".proxyPass = "https://127.0.0.1:8920"; #https*/
        /*locations."/bio".return = "302 $scheme://$host/bio/";*/
        /*locations."/bio/".proxyPass = "https://127.0.0.1:8920";*/
      };
    })
    ({
      networking.firewall = {
        allowedTCPPorts = [ 80 443 3000 ]; #TODO ports
        allowedUDPPorts = [ 80 443 3000 ];
      };
    })
    ({ 
      security.acme = {
        acceptTerms = true;
        defaults = {
          email = cfg.email;
          webroot = "/var/lib/acme/acme-challenge";
        };
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
      environment.systemPackages = with pkgs; [
        jellyfin
        jellyfin-web
        jellyfin-ffmpeg
        jellycli
      ];
      networking.firewall = {/*
        allowedTCPPorts = [ 8096 8920 ];
        allowedUDPPorts = [ 8096 8920 ];
      */};
    })
    ({
      services.nextcloud = {
        enable = true;
        package = pkgs."nextcloud${cfg.version}";
        maxUploadSize = "16G";
        cli.memoryLimit = "2G";
        #https = true; #HTTPS for generated links
        hostName = "moln.kevindybeck.com";
        home = "/var/lib/nextcloud/5tb/nextcloud"; #"Storage path of nextcloud"
          /* Nextcloud’s data storage path. 
            Will be services.nextcloud.home by default. 
            This folder will be populated with a config.php file 
            and a data folder which contains the state of the instance 
            (excluding the database) 
          */
        #datadir = "/var/lib/nextcloud/5tb/nextcloud";
        /*secretFile = "path"; #{"redis":{"password":"secret"}}*/
        phpOptions = {
          catch_workers_output = "yes"; # def
          display_errors = "stderr"; # def
          error_reporting = "E_ALL & ~E_DEPRECATED & ~E_STRICT"; # def
          expose_php = "Off"; # def
          "opcache.fast_shutdown" = "1"; # def
          "opcache.interned_strings_buffer" = "16"; # def: "8"
          "opcache.max_accelerated_files" = "10000"; # def
          "opcache.memory_consumption" = "128"; # def
          "opcache.revalidate_freq" = "1"; # def
          "openssl.cafile" = "/etc/ssl/certs/ca-certificates.crt";
          output_buffering = "0"; # def
          short_open_tag = "Off"; # def
          instanceid = "ocvufs9qxu02";
          passwordsalt = "XDtrXybh8uBcOgIATWsJ7zV+h07pHt";
          secret = "Uf6KwmcYdtW1WkvlvNrOaoLdvhH8EDsPZWnG66/ALHU17fAO";
          dbtableprefix = "oc_";
          #mysqlutf8mb' =" tru";
          #installed = "ru";
          default_locale = "sv_SE";
          default_phone_region = "SE";
          twofactor_enforced = "false";
          "bulkupload.enabled" = "false";
          "htaccess.RewriteBase" = "/";
          theme = "";
        };
        nginx.recommendedHttpHeaders = false;
        settings = {
          trusted_domains = ["192.168.1.12"];
	        trusted_proxies = ["192.168.1.1"];	
          # skeletondirectory "";
          loglevel = 1; # [0:debug, 1:info, [2]:warn, 3:error, 4:fatal]
          log_type = "syslog"; #"errorlog", ["syslog"], "systemd", "file"
        };
        # configureRedis = true;
        #database.createLocally = true;
        config = {
          adminpassFile = cfg.pwfile;# "string";
          dbuser = "nextcloud";
          dbtype = "mysql"; #"sqlite", "pgsql", "mysql"
          dbname = "nextcloud";
          #adminuser = "admin";
          #dbtableprefix = "oc_"; #"string"
          dbpassFile = "/pw/pw"; #"string"*/
        };
      };

      services.mysql = {
        ensureDatabases = [ "nextcloud" ];
        ensureUsers = [{ 
          name = "nextcloud";   
          ensurePermissions = { 
            "nextcloud.*" = "ALL PRIVILEGES"; 
            "nextcloudaux.*" = "ALL PRIVILEGES"; 
          }; 
        ]; };
      };
    })
    ({
      services.nextcloud = {
          /*
          Allow the installation and updating of apps from the Nextcloud appstore.
          Enabled by default unless there are packages in services.nextcloud.extraApps.
          Set this to true to force enable the store even if services.nextcloud.extraApps is used.
          Set this to false to disable the installation of apps from the global appstore.
          App management is always enabled regardless of this setting.
          */
        appstoreEnable = false;

        autoUpdateApps = { # auto-update of all apps installed from the Nextcloud app store
          enable = false;
          startAt = "05:00:00";
        };

          /* 
            Automatically enable the apps in services.nextcloud.extraApps every time Nextcloud starts.
            If set to false, apps need to be enabled in the Nextcloud web user interface or with nextcloud-occ app:enable.
          */
        extraAppsEnable = false;

          /*
          Using this will disable the appstore to prevent Nextcloud from updating these apps (see services.nextcloud.appstoreEnable).
          Extra apps to install.
          Should be an attrSet of appid to packages generated by fetchNextcloudApp.
          The appid must be identical to the “id” value in the apps appinfo/info.xml.
          */
        extraApps = { inherit (config.services.nextcloud.package.packages.apps)
          bookmarks
          #calendar
          contacts
          cospend
          deck
          phonetrack
          tasks
        ;};
      };
    })
    ({
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
      
    
    })
    /*({
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
    })*/
    ({
      /* commented lines */
      /*services.nginx.virtualHosts."192.168.1.12" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://moln.kevindybeck.com";
          proxyPass = "http://127.0.0.1:80";
        };
        root = "/var/lib/nextcloud/nginx";
      };*/
      /*services.nginx.virtualHosts."bajs.korv.lol" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://127.0.0.1:1337";
      };*/
      /*services.nginx.virtualHosts."react.korv.lol" = {
        forceSSL = true;
        enableACME = true;
        #locations."/".proxyPass = "http://127.0.0.1:3000";
        locations."/".proxyPass = "http://192.168.1.10:3000";
      };*/
      /*services.nginx.virtualHosts."smp.korv.lol" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://127.0.0.1:8000";
        locations."/".proxyPass = "https://127.0.0.1:5223";
      };*/
      /*services.nginx.virtualHosts."xftp.korv.lol" = {
        forceSSL = true;
        enableACME = true;
        #locations."/".proxyPass = "http://127.0.0.1:8443";
        locations."/".proxyPass = "https://127.0.0.1:8443";
      };*/
    })
    /*({

    })
    ({ 
    })*/
   ]);
}

