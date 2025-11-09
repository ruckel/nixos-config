{ lib, pkgs, config, ... } :
with lib;
let cfg = config.nginx;
in
{
options.nginx = {
  enable = mkEnableOption "nginx";
  lab = mkEnableOption "";
  deno = mkEnableOption "";
};

config = mkIf cfg.enable (mkMerge [
  ({
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      statusPage = true;
    };
    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 80 443 ];
    };
  })
  ( mkIf cfg.lab {
    services.nginx.virtualHosts = {
      "lab.kevindybeck.com" = {
        serverAliases = [ "192.168.1.12" "4.20.69.0" ];
        root = "/var/lib/www/";
        addSSL = true; # set defaults for listen to listen on all interfaces on the respective default ports (80, 443)
        sslCertificate = "/etc/letsencrypt/live/kevindybeck.com-0001/fullchain.pem";
        sslCertificateKey = "/etc/letsencrypt/live/kevindybeck.com-0001/privkey.pem";
        locations = {
          "/".proxyPass = "http://localhost:8080/"; #trailing / improtant
          "/jf/".proxyPass = "http://localhost:8096/"; #trailing / improtant
        };
      };
      "config.services.nextcloud.hostName" = {
        serverAliases = [ "moln.kevindybeck.com" "nc.kevindybeck.com" ];
        root = "/var/lib/nextcloud/5tb/nextcloud/";
        addSSL = true; # set defaults for listen to listen on all interfaces on the respective default ports (80, 443)
        sslCertificate = "/etc/letsencrypt/live/kevindybeck.com-0001/fullchain.pem";
        sslCertificateKey = "/etc/letsencrypt/live/kevindybeck.com-0001/privkey.pem";
        locations = {
          "/".proxyPass = "http://localhost:8080/"; #trailing / improtant
          "/jf/".proxyPass = "http://localhost:8096/"; #trailing / improtant
        };
      };
    };
  })
  ( mkIf cfg.deno {
    services.nginx.virtualHosts.localhost.locations."/".proxyPass = "http://localhost:3000";
  })
]);
}
