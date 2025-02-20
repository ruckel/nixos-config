{ lib, pkgs, config, ... } :
with lib;
let cfg = config.TEMPLATE;
in {
  options.TEMPLATE = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}
    enable = mkEnableOption "DESCRIPTION";

    user = mkOption { default = "user";
      description = "";
      type = types.str;
     };
    strings = mkOption {
      description = "";
      type = with types; nullOr listOf str;
     };
   };

  config = mkIf cfg.enable (mkMerge [
    (mkIf {})
    (mkIf {})
    # static config here
   ]);
}
