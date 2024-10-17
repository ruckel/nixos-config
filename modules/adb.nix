{ lib, pkgs, config, inputs, ... } :
with lib;
let
  cfg = config.adb;
in {
  options.adb = {
    enable = mkEnableOption "custom adb conf";
    user = mkOption {
      type = with types; nullOr str;
      default = "korv";/*vars.user;*/
    };
  };

  config = lib.mkIf cfg.enable {
    programs.adb.enable = true;
    users.users.${cfg.user}.extraGroups = [ "adbusers" ];
    networking.firewall = {
    allowedTCPPorts = [ 5555 ]; #TODO ports
    allowedUDPPorts = [ 5555 ];
    };
  };
}