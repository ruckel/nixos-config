{ lib, pkgs, config, ... } :
with lib;
let
  cfg = config.experimental;
in
{
  options.experimental = {
    enable                  = mkEnableOption "experimental";
    user = mkOption { default = "user";
      type = types.str;
    };

    enableSystembus-notify  = mkEnableOption "";
    enableAvahi             = mkEnableOption "";
    enableRustdeskServer    = mkEnableOption "";
    enableVirtualScreen     = mkEnableOption "";
    enableVncFirewall       = mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    services.systembus-notify.enable = cfg.enableSystembus-notify;
    qt.style = "adwaita-dark";
    services.avahi.enable = cfg.enableAvahi;
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
    services.rustdesk-server = {
      enable = cfg.enableRustdeskServer;
      openFirewall = true;
      relayIP = "127.0.0.1";
    };


  };
}