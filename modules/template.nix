{ lib, pkgs, config, ... } :
with lib;
let cfg = config.TEMPLATE;
in {
  options.TEMPLATE = {
    enable = mkEnableOption "DESCRIPTION";

    user = mkOption { default = "user";
      type = types.str;
    };
    };

  config = lib.mkIf cfg.enable {

  };
}