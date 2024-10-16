{ lib, pkgs, config, inputs, ... } :
with lib;
let
  cfg = config.adb;
  #vars = import ../vars.nix;
  vars = inputs.vars;
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
    users.users."korv"/*${vars.user}*/.extraGroups = [ "adbusers" ];
    networking.firewall = {
    allowedTCPPorts = [ 5555 ];
    allowedUDPPorts = [ 5555 ];
    };
  };
}