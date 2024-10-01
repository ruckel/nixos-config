{ lib, pkgs, config, ... } :
with lib;
let args = {
  cfg = config.experimental;
  vars = import ../vars.nix;
};
in {
  options.experimental = {
    enable                  = mkEnableOption "experimental";

    docker                  = mkEnableOption "";
    enableSystembus-notify  = mkEnableOption "";
    enableAvahi             = mkEnableOption "";
    enableRustdeskServer    = mkEnableOption "";
    enableVirtualScreen     = mkEnableOption "";
    enableVncFirewall       = mkEnableOption "";
  };

  config = lib.mkIf args.cfg.enable {
    services.systembus-notify.enable = args.cfg.enableSystembus-notify;
    qt.style = "adwaita-dark";
    services.mysql.package = pkgs.mariadb;
    services.avahi.enable = args.cfg.enableAvahi;
    networking.firewall = lib.mkIf args.cfg.enableVncFirewall {
      allowedTCPPorts = [ 5900 ];
      allowedUDPPorts = [ 5900 ];
    };
    services.xserver = lib.mkIf args.cfg.enableVirtualScreen {
      virtualScreen = { x = 1720; y = 1440; };
    };
    services.rustdesk-server = {
      enable = args.cfg.enableRustdeskServer;
      openFirewall = true;
      relayIP = "127.0.0.1";
    };


virtualisation.docker.enable = true;
users.users.${args.vars.user}.extraGroups = [ "docker" ];
  };
}