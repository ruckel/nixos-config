{ lib, pkgs, config, ... } :
with lib;
let cfg = config.fail2ban;
in {
  options.fail2ban = {
    enable = mkEnableOption "fail2ban";
   };

  config = mkIf cfg.enable (mkMerge [
    /*(mkIf {})
    (mkIf {})*/
    ({
      services.fail2ban = {
        enable              = true;
        ignoreIP = [
            "192.168.0.0/16"
         ];
        bantime /*d:10m*/   = "30m";
        jails = {
          apache-nohome-iptables = {
            settings = {
              # Block an IP address if it accesses a non-existent
              # home directory more than 5 times in 10 minutes,
              # since that indicates that it's scanning.
              filter = "nginx-nohome";
              action = ''iptables-multiport[name=HTTP, port="http,https"]'';
              logpath = "/var/log/httpd/error_log*";
              backend = "auto";
              findtime = 600;
              bantime = 600;
              maxretry = 5;
            };
          };
         };
       };
      services.openssh.settings.logLevel = "VERBOSE";
    })
   ]);
}
