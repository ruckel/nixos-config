{ lib, pkgs, config, vars, ... } : with lib; let
  cfg = config.experimental;
in {
  options.experimental = {
    enable = mkEnableOption "experimental";
    enableSystembus-notify  = mkEnableOption "";
    enableRustdeskServer = mkEnableOption "";
    enableVirtualScreen = mkEnableOption "";
    enableVncFirewall = mkEnableOption "";
  };

  config = mkIf cfg.enable (mkMerge [
    ({
      qt.style = "adwaita-dark";
      services.dnsmasq = {
        enable = false;
        #configFile = ;
        settings = {
          server = [ "1.1.1.1" "8.8.8.8" ];
        };
        #resolveLocalQueries = true;
        #alwaysKeepRunning = false;
       };
      #networking.networkmanager.dns = "dnsmasq";
      #networking.nameservers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];
      #networking.resolvconf.useLocalResolver = true;
      #networking.hosts = {
      #  "127.0.0.1" = [ "localhost" "localkorv" ];
      #  "::1" = [ "localhost" "localkorv" ];
      #  "192.168.1.10" = [ "burk.korv.lol" ];
      #  "192.168.1.12" = [ "m.kevindybeck.com" ];
      # };
      #networking.hostFiles = []; # Files that should be concatenated together to form /etc/hosts
      networking.firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };
     })
    ( mkIf cfg.enableSystembus-notify {
      services.systembus-notify.enable = true;
     })
    ( mkIf cfg.enableVncFirewall{
      networking.firewall = {
        allowedTCPPorts = [ 5900 ];
        allowedUDPPorts = [ 5900 ];
      };
      programs.virt-manager = {
        enable = true;
      };
     })
    ( mkIf cfg.enableVirtualScreen {
      services.xserver.virtualScreen = { x = 1720; y = 1440; };
     })
    ( mkIf cfg.enableRustdeskServer {
      services.rustdesk-server = {
        enable = cfg.enableRustdeskServer;
        openFirewall = true;
        relayIP = "127.0.0.1";
       };
     })
  ]);
}
