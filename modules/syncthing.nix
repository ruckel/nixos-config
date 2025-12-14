{lib, pkgs, config, userName, ... } : with lib; let
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
      user = userName;
      dataDir = "/home/${userName}/syncthing";
      configDir = "/home/${userName}/.config/syncthing";
      #systemService = true; #databaseDir =
      openDefaultPorts = true;
    };
    users.users.${userName}.extraGroups = [ "syncthing" ];
  };
}
