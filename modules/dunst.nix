{ lib, pkgs, config, ... } :
with lib;
let cfg = config.dunst-service;
in {
  options.dunst-service = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}
    enable = mkEnableOption "DESCRIPTION";

    user = mkOption { default = "user";
      type = types.str;
     };
    strings = mkOption {
      description = "";
      type = with types; nullOr listOf str;
      };
   };

  config = mkIf cfg.enable (mkMerge [
    #(mkIf {})
    #(mkIf {})
    ({
      environment.systemPackages = with pkgs; [ dunst ];
    })
   ]);
}
