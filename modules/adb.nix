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
    scrcpy = mkEnableOption "Remote screen";
  };

  config = mkIf cfg.enable (mkMerge [
    ({
      programs.adb.enable = true;
      users.users.${cfg.user}.extraGroups = [ "adbusers" ];
      networking.firewall = {
        allowedTCPPorts = [ 5555 ]; #TODO ports
        allowedUDPPorts = [ 5555 ];
      };
    })
    ( mkIf cfg.scrcpy {
      services.avahi.enable = true;

      environment.systemPackages = with pkgs; [ scrcpy ];
    })
  ]);
}