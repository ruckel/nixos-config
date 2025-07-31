{ lib, pkgs, config, ... } :
with lib;
let cfg = config.simplex;
in {
  options.simplex = {
    enable = mkEnableOption "DESCRIPTION";

    user = mkOption { default = "user";
      type = types.str;
    };
    };

  config = lib.mkIf cfg.enable {

  };
}
