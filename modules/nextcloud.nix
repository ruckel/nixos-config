{ lib, pkgs, config, ... }:
with lib;
let
cfg = config.nc;
ncversion = "30";
in
{
  options.nc.= {
    enable = mkEnableOption "";
    version = mkOption {
      default = "30";
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
    /*(mkIf {})
    (mkIf {})*/
    ({
      services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      };
      services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
        forceSSL = true;
        enableACME = true;
        /*locations."/".proxyPass = "http://127.0.0.1:8920";*/
        /*locations."/bio".return = "302 $scheme://$host/bio/";*/
        /*locations."/bio/".proxyPass = "https://127.0.0.1:8920";*/
      };
      services.nginx.virtualHosts.${cfg.jellyfin.hostName} = mkIf cfg.jellyfin.enable {
        forceSSL = true;
        enableACME = true;
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
        defaults.email = cfg.email;
        certs.${config.services.nextcloud.hostName}.email = cfg.email;
        /* 
          - Exactly one of the options:
          security.acme.certs.moln.kevin.dybeck.com.dnsProvider`,
          security.acme.certs.moln.kevin.dybeck.com.webroot,
          security.acme.certs.moln.kevin.dybeck.com.listenHTTP = true;
          security.acme.certs.moln.kevin.dybeck.com.s3Bucket
        */
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
      security.acme.certs.${cfg.jellyfin.hostName}.email = cfg.email; 
      networking.firewall = {/*
        allowedTCPPorts = [ 8096 8920 ];
        allowedUDPPorts = [ 8096 8920 ];
      */};
    })
    ({
      services.nextcloud = {
        enable = true;
        package = pkgs."nextcloud${ncversion}";
        maxUploadSize = "16G";
        cli.memoryLimit = "2G";
        https = true; #HTTPS for generated links
        hostName = "moln.kevindybeck.com";
        /*home = "";*/
        datadir = "/var/lib/nextcloud/5tb/nextcloud";
        /*secretFile = "path"; #{"redis":{"password":"secret"}}*/
        appstoreEnable = true;
        phpOptions = {
          catch_workers_output = "yes";
          display_errors = "stderr";
          error_reporting = "E_ALL & ~E_DEPRECATED & ~E_STRICT";
          expose_php = "Off";
          "opcache.fast_shutdown" = "1";
          "opcache.interned_strings_buffer" = "16";
          "opcache.max_accelerated_files" = "10000";
          "opcache.memory_consumption" = "128";
          "opcache.revalidate_freq" = "1";
          "openssl.cafile" = "/etc/ssl/certs/ca-certificates.crt";
          output_buffering = "0";
          short_open_tag = "Off";
          instanceid = "ocvufs9qxu02";
          passwordsalt = "XDtrXybh8uBcOgIATWsJ7zV+h07pHt";
          secret = "Uf6KwmcYdtW1WkvlvNrOaoLdvhH8EDsPZWnG66/ALHU17fAO";
          logfile = "/var/log/nextcloud";
          dbtype = "mysql";
          dbtableprefix = "oc_";
          mysqlutf8mb' =" tru";
          installed = "ru";
          default_locale = "sv_SE";
          default_phone_region = "SE";
          twofactor_enforced = "false";
          "bulkupload.enabled" = "false";
          maintenance = "false";
          "htaccess.RewriteBase" = "/";
          theme = "";
        };
        nginx.recommendedHttpHeaders = false;
        settings = {
          trusted_domains = ["192.168.1.12" "moln.korv.lol" /*"bajs.korv.lol"*/ "80.216.24.170" ];
	        trusted_proxies = ["192.168.1.1"];	
          # skeletondirectory "";
          loglevel = 1; # [0:debug, 1:info, 2:warn, 3:error, 4:fatal]
          log_type = "file"; #"errorlog", "syslog", "syslog", "systemd"
        };
        # configureRedis = ;
        database.createLocally = true;
        config = {
          adminpassFile = cfg.pwfile;# "string";
          dbuser = "nextcloud";
          dbtype = "mysql"; #"sqlite", "pgsql", "mysql"
          dbname = "nextcloud";
          /* #adminuser = "admin";
          dbtableprefix = "oc_"; #"string"
          dbpassFile = null; #"string"*/
        };
        autoUpdateApps = {
          enable = true;
          startAt = "05:00:00";
        };
        extraAppsEnable = true;
        extraApps ={
          inherit (config.services.nextcloud.package.packages.apps)
          bookmarks
          #calendar
          contacts
          cookbook
          cospend
          deck
          #files_texteditor
          #files_markdown
          mail
          music
          notes
          phonetrack
          tasks
          ;
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
        };
      };
    })
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

    })
    ({ 
    })*/
   ]);
}

