{ lib, pkgs, config, ... } :
with lib;
let cfg = config.TEMPLATE;
in {
  options.TEMPLATE = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}
    enable = mkEnableOption "DESCRIPTION";
    opt1 = mkEnableOption "";
    opt2 = mkEnableOption "";

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
    ({ #static config

    })
    (mkIf cfg.opt1 {
      
    })
    (mkIf cfg.opt2 {
      
    })
   ]);
}
