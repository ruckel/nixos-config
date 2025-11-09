{ lib, pkgs, config, ... } :
with lib;
let cfg = config.TEMPLATE;
in {
  options.TEMPLATE = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}
    enable = mkEnableOption "DESCRIPTION";
    enable2 = mkOption {
        type = types.bool;
        default = false;
        description = "placeholder";

    };
    printOptDuringEval = mkEnableOption "";
    opt2 = mkEnableOption "";

    user = mkOption {
      default = "user";
      description = "";
      type = types.str;
     };
    strings = mkOption {
      description = "";
      type = with types; nullOr listOf str;
     };
   };

  config = mkIf cfg.enable (mkMerge [
    ({ #static config

    })
    (mkIf cfg.printOptDuringEval {
      util.trace = [ "TEMPLATE: printOptDuringEval: ${toString printOptDuringEval}" ];
    })
    (mkIf cfg.opt2 {

    })
   ]);
}
