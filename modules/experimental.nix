{ lib, pkgs, config, vars, ... } :
with lib;
let
  cfg = config.experimental;
in
{
  options.experimental = {
    enable                  = mkEnableOption "experimental";
    enableSystembus-notify  = mkEnableOption "";
    enableRustdeskServer    = mkEnableOption "";
    enableVirtualScreen     = mkEnableOption "";
    enableVncFirewall       = mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    services.systembus-notify.enable = cfg.enableSystembus-notify;
    qt.style = "adwaita-dark";
    networking.firewall = lib.mkIf cfg.enableVncFirewall {
      allowedTCPPorts = [ 5900 ];
      allowedUDPPorts = [ 5900 ];
    };
    programs.virt-manager = lib.mkIf cfg.enableVncFirewall {
      enable = true;
    };
    services.xserver = lib.mkIf cfg.enableVirtualScreen {
      virtualScreen = { x = 1720; y = 1440; };
    };
/*    services.rustdesk-server = {
      enable = cfg.enableRustdeskServer;
      openFirewall = true;
      relayIP = "127.0.0.1";
    };
*/

  };
}
