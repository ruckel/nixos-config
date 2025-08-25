{ lib, pkgs, config, ... } :
with lib;
let cfg = config.nginx;
in {
  options.nginx = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}
    enable = mkEnableOption "nginx";

    user = mkOption { default = "user";
      description = "";
      type = types.str;
     };
    strings = mkOption {
      description = "";
      type = with types; nullOr listOf str;
     };
   };

  config = mkIf cfg.enable (mkMerge [
    (mkIf {})
    (mkIf {})
    # static config here
    ({
    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.email;
    };
   #services.nginx.virtualHosts."bajs.korv.lol" = {
   #  forceSSL = true;
   #  enableACME = true;
   #  location."/bajs".return = "302 $scheme://$host/";
   #  locations."/".proxyPass = "http://127.0.0.1:1337";
   #};
   #services.nginx.virtualHosts."react.korv.lol" = {
   #  forceSSL = true;
   #  enableACME = true;
   ## locations."/".proxyPass = "http://127.0.0.1:3000";
   #  locations."/".proxyPass = "http://192.168.1.10:3000";
   #};
   #services.nginx.virtualHosts."smp.korv.lol" = {
   #  forceSSL = true;
   #  enableACME = true;
   #  locations."/".proxyPass = "http://127.0.0.1:8000";
   # #locations."/".proxyPass = "https://127.0.0.1:5223";
   #};
   #services.nginx.virtualHosts."xftp.korv.lol" = {
   #  forceSSL = true;
   #  enableACME = true;
   # #locations."/".proxyPass = "http://127.0.0.1:8443";
   #  locations."/".proxyPass = "https://127.0.0.1:8443";
   #};
   })
   ]);
}
