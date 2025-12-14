{ lib, pkgs, config, userName, ... } : with lib; let
  cfg = config.TEMPLATE;
in {
  options.TEMPLATE = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}
    enable = mkEnableOption "placeholder";
    enable2 = mkOption {
        type = types.bool;
        default = false;
        description = "placeholder";

    };
    printOptDuringEval = mkEnableOption "placeholder";
    opt2 = mkEnableOption "placeholder";

    symlinks = mkOption {
      type = with types; listOf str;
      description = "List of directories to be symlinked in `/run/current-system/sw`";
      default = [  ];
    };

    user = mkOption {
      default = /* userName */ "user";
      description = "username to use";
      type = types.str;
     };
    strings = mkOption {
      description = "placeholder";
      type = with types; nullOr listOf str;
     };
   };

  config = mkIf cfg.enable (mkMerge [
    ( /* static config */ {
      environment.pathsToLink = cfg.symlinks;
    })
    (mkIf cfg.printOptDuringEval {
      util.trace = [ "TEMPLATE: printOptDuringEval: ${toString printOptDuringEval}" ];
    })
    (mkIf cfg.opt2 {

    })
   ]);
}
