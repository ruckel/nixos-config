{ lib, pkgs, config, ... } :
with lib;
let cfg = config.TEMPLATE;
in {
  options.TEMPLATE = {
    enable = mkEnableOption "DESCRIPTION";

    };

  config = lib.mkIf cfg.enable {

  };
}