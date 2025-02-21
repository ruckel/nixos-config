{ lib, pkgs, config, ... }:
with lib;
let
cfg = config.nc;
ncversion = "30";
in
{
  options.nc.enable = mkEnableOption "";
  options.nc.email = mkOption {
    type = types.str;
    default = "kevin.dybeck@yahoo.com";
  };
  options.nc.pwfile = mkOption {
    type = types.str;
    default = "";
  };
  options.nc.jf.hostName = mkOption {
    type = types.str;
    default = "tv.korv.lol" ;#"bio.kevindybeck.com";
  };

  config = lib.mkIf cfg.enable {


    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };
    services.nginx.virtualHosts."192.168.1.12" = {
    # forceSSL = true;
     #enableACME = true;
    #locations."/" = {
     # proxyPass = "http://moln.kevindybeck.com";
     # proxyPass = "http://127.0.0.1:8096";
    #};
      locations."/bio".return = "302 $scheme://$host/bio/";
      locations."/bio/" = {
      # proxyPass = "http://bio.kevindybeck.com/bio/";
      ##  proxyPass = "http://127.0.0.1:8096/bio";
        proxyPass = "http://127.0.0.1:8096";
      };
    };
    services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      ## /* moln.kevindybeck.com */
      forceSSL = true;
      enableACME = true;
      locations."/bio".return = "302 $scheme://$host/bio/";
      locations."/bio/".proxyPass = "https://127.0.0.1:8920";
    };
    services.nginx.virtualHosts.${cfg.jf.hostName} = {
      ## /* tv.korv.lol */
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://127.0.0.1:8096";
      locations."/bio".return = "302 $scheme://$host/bio/";
      locations."/bio/".proxyPass = "https://127.0.0.1:8920";
    };
    services.nginx.virtualHosts."bajs.korv.lol" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://127.0.0.1:1337";
    };
    services.nginx.virtualHosts."react.korv.lol" = {
      forceSSL = true;
      enableACME = true;
    # locations."/".proxyPass = "http://127.0.0.1:3000";
      locations."/".proxyPass = "http://192.168.1.10:3000";
    };
    services.nginx.virtualHosts."smp.korv.lol" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://127.0.0.1:8000";
     #locations."/".proxyPass = "https://127.0.0.1:5223";
    };
    services.nginx.virtualHosts."xftp.korv.lol" = {
      forceSSL = true;
      enableACME = true;
     #locations."/".proxyPass = "http://127.0.0.1:8443";
      locations."/".proxyPass = "https://127.0.0.1:8443";
    };
    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.email;
      certs = {
        ${config.services.nextcloud.hostName}.email =   cfg.email;
        ${cfg.jf.hostName}.email =                      cfg.email;
        "bajs.korv.lol".email =                         cfg.email;
        "react.korv.lol".email =                        cfg.email;
      };
    };
     # - Exactly one of the options
  # security.acme.certs.moln.kevin.dybeck.com.dnsProvider`,
  # security.acme.certs.moln.kevin.dybeck.com.webroot,
  # security.acme.certs.moln.kevin.dybeck.com.listenHTTP
  # security.acme.certs.moln.kevin.dybeck.com.s3Bucket
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
     networking.firewall = {
       allowedTCPPorts = [ 80 443 3000 8096 8920 ]; #TODO ports
       allowedUDPPorts = [ 80 443 3000 8096 8920 ];
    };
    services.nextcloud = {
      enable = true;
      package = pkgs."nextcloud${ncversion}";
      maxUploadSize = "1G";

      https = true;
      hostName = "moln.kevindybeck.com";
      #home = "";
      datadir = "/var/lib/nextcloud/5tb/nextcloud";
      #secretFile = "path"; #{"redis":{"password":"secret"}}
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
        #memory_limit = "512";
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
        #twofactor_enforced_groups = array ();
        "bulkupload.enabled" = "false";
        maintenance = "false";
        maintenance_window_start = "4";
        #app_install_overwrite = "array (0 => 'sharerenamer')";
        "htaccess.RewriteBase" = "/";
        #mail_from_address = "kevin.dybeck";
        #mail_smtpmode = "smtp";
        #mail_sendmailmode = "smtp";
        #mail_domain = "gmail.com";
        #mail_smtphost = "smtp.gmail.com";
        #mail_smtpport = "465";
        #mail_smtpauth = "1";
        #mail_smtpname = "kevin.dybeck@gmail.com";
        #mail_smtppassword = "mvki bkbv cnzz nikx";
        #mail_smtpdebug = "als";
        #mail_smtpsecure = "ssl";
        theme = "";
      };
      settings = {
        trusted_domains = ["192.168.1.12" "moln.korv.lol" /*"bajs.korv.lol"*/ ];
	trusted_proxies = ["192.168.1.1"];	
      # skeletondirectory "";
        loglevel = 1; # [0:debug, 1:info, 2:warn, 3:error, 4:fatal]
        log_type = "file"; #"errorlog", "syslog", "syslog", "systemd"
      };
    # configureRedis = ;
      database.createLocally = true;
      config = {
       #adminuser = "admin";
       adminpassFile = cfg.pwfile;# "string";
        dbuser = "nextcloud";
        dbtype = "mysql"; #"sqlite", "pgsql", "mysql"
        dbname = "nextcloud";
        #dbtableprefix = "oc_"; #"string"
        #dbpassFile = null; #"string"
      };
      autoUpdateApps = {
        enable = true;
        startAt = "05:00:00";
      };
      extraAppsEnable = true;
      extraApps ={
        #inherit ("pkgs.nextcloud${ncversion}Packages.apps")
        inherit (config.services.nextcloud.package.packages.apps) #(pkgs.nextcloud30Packages.apps)
        bookmarks
        calendar
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
        #sharerenamer = pkgs.fetchNextcloudApp {
        #  #name = "sharerenamer";
        #  sha256 = "74d46c22ed0f24a6fe00b2acf8e7f6a3a469ed00984ee035277c5ac9f605908e";
        #  license = "AGPL";
        #  url = "https://github.com/JonathanTreffler/sharerenamer/releases/download/v3.4.0/sharerenamer.tar.gz";
        #  #version = "3.4.0";
        #};
        #timemanager = pkgs.fetchNextcloudApp {
        #  #name = "timemanager";
        #  sha256 = "a4594a3bc8c6239c1ab7df7ceaedc517065e4ca6401fbd4fa553306e5cdffec5";
        #  license = "AGPL";
        #  url = "https://github.com/te-online/timemanager/archive/refs/tags/v0.3.16.tar.gz";
        #  #version = "0.3.16";
        #};
      };
    };
  };
}

