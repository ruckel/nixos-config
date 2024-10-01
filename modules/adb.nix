{ lib, pkgs, config, ... } :
with lib;
let args = {
  cfg = config.adb;
  vars = import ../vars.nix;
};
in {
  options.adb = {
    enable = mkEnableOption "custom adb conf";
    user = mkOption {
      type = with types; nullOr str;
      default = args.vars.user;
    };
  };

  config = lib.mkIf args.cfg.enable {
    programs.adb.enable = true;
    users.users.${args.vars.user}.extraGroups = [ "adbusers" ];
    networking.firewall = {
    allowedTCPPorts = [ 5555 ];
    allowedUDPPorts = [ 5555 ];
    };
  };
}