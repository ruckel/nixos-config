{ lib, pkgs, config, vars, ... } :
with lib;
let cfg = config.transmission;
in {
  options.transmission = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}
    enable = mkEnableOption "DESCRIPTION";

    dir = mkOption {
      default = "/var/lib/transmission";
      description = "";
      type = types.str;
     };
   };

  config = mkIf cfg.enable (mkMerge [
    /*(mkIf {})*/
    /*(mkIf {})*/
    ({
      services.transmission = {
        enable = true;
        home = cfg.dir;
        openRPCPort = true;
        settings.rpc-bind-address = "0.0.0.0";
        credentialsFile = "/var/lib/secrets/transmission/settings.json";
      };
        users.users."${vars.username-admin}".extraGroups = ["transmission"];
    })
   ]);
}
