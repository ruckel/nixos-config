{ lib, pkgs, config, ... } :
with lib;
let
  cfg = config.syncthing;
in {
  options.syncthing = {
    enable = mkEnableOption "DESCRIPTION";

    user = mkOption { default = "user";
      type = types.str;
    };
    };

  config = lib.mkIf cfg.enable {
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
    services.syncthing = {
      enable = true;
      user = cfg.user;
      dataDir = "/home/${cfg.user}/syncthing";
      configDir = "/home/${cfg.user}/.config/syncthing";
      #systemService = true; #databaseDir =
    };
    users.users.${cfg.user}.extraGroups = [ "syncthing" ];
  };
}