{ lib, pkgs, config, vars, ... } :
with lib;
let
  cfg = config.syncthing;
in {
  options.syncthing = {
    enable = mkEnableOption "DESCRIPTION";

    };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 21027 ];
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
    services.syncthing = {
      enable = true;
      user = vars.username-admin;
      dataDir = "/home/${vars.username-admin}/syncthing";
      configDir = "/home/${vars.username-admin}/.config/syncthing";
      #systemService = true; #databaseDir =
    };
    users.users.${vars.username-admin}.extraGroups = [ "syncthing" ];
  };
}
