{ lib, pkgs, config, ... }:
with lib;
let cfg = config.nc;
in
{
  options.nc.enable = mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud27;
      maxUploadSize = "";

      https = true;
      hostName = "localhost";
      #home = "";
      #datadir = "";
      #secretFile = "path"; #{"redis":{"password":"secret"}}

      appstoreEnable = true;
      phpOptions = {
        catch_workers_output = "yes";
        display_errors = "stderr";
        error_reporting = "E_ALL & ~E_DEPRECATED & ~E_STRICT";
        expose_php = "Off";
        "opcache.fast_shutdown" = "1";
        "opcache.interned_strings_buffer" = "8";
        "opcache.max_accelerated_files" = "10000";
        "opcache.memory_consumption" = "128";
        "opcache.revalidate_freq" = "1";
        "openssl.cafile" = "/etc/ssl/certs/ca-certificates.crt";
        output_buffering = "0";
        short_open_tag = "Off";
        instanceid = "ocvufs9qxu02";
        passwordsalt = "XDtrXybh8uBcOgIATWsJ7zV+h07pHt";
        secret = "Uf6KwmcYdtW1WkvlvNrOaoLdvhH8EDsPZWnG66/ALHU17fAO";
        logfile = "/var/log/nextcloud.log";
        dbtype = "mysql";
        #version = "26.0.13.1";
        dbtableprefix = "oc_";
        mysqlutf8mb' =" tru";
        installed = "ru";
        default_locale = "sv_SE";
        default_phone_region = "SE";
        twofactor_enforced = "false";
        #twofactor_enforced_groups = array ();
        "bulkupload.enabled" = "false";
        maintenance = "false";
        #app_install_overwrite = "array (0 => 'sharerenamer')";
        "htaccess.RewriteBase" = "/";
        mail_from_address = "kevin.dybeck";
        mail_smtpmode = "smtp";
        mail_sendmailmode = "smtp";
        mail_domain = "gmail.com";
        mail_smtphost = "smtp.gmail.com";
        mail_smtpport = "465";
        mail_smtpauth = "1";
        mail_smtpname = "kevin.dybeck@gmail.com";
        mail_smtppassword = "mvki bkbv cnzz nikx";
        mail_smtpdebug = "als";
        mail_smtpsecure = "ssl";
        theme = "";
      };
      settings = {
      # trusted_domains = "";
      # skeletondirectory "";
        loglevel = 2;
        log_type = "syslog"; #"errorlog", "file", "syslog", "systemd"
      };
    # configureRedis = ;
      database.createLocally = true;
      config = {
        adminpassFile = "/run/secrets/nc-admin-pw";# "string";
        dbuser = "nextcloud";
        dbtype = "mysql"; #"sqlite", "pgsql", "mysql"
        dbname = "nextcloud";
        #dbtableprefix = "oc_"; #"string"
        #dbpassFile = null; #"string"
      };
      autoUpdateApps = {
        enable = true;
        startAt = "Mon 02:00:00";
      };
      #extraApps ={
      #  inherit (pkgs.nextcloud25Packages.apps) mail calendar contact;
      #  phonetrack = pkgs.fetchNextcloudApp {
      #    name = "phonetrack";
      #    sha256 = "0qf366vbahyl27p9mshfma1as4nvql6w75zy2zk5xwwbp343vsbc";
      #    url = "https://gitlab.com/eneiluj/phonetrack-oc/-/wikis/uploads/931aaaf8dca24bf31a7e169a83c17235/phonetrack-0.6.9.tar.gz";
      #    version = "0.6.9";
      #  };
      #};
    };
  };
}

