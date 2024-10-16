{ lib, pkgs, config, ... } :
with lib;
let cfg = config.hwConf;
in {
  options.hwConf = {
    enable = mkEnableOption "custom hardware configuration";

  };

  config = lib.mkIf cfg.enable {
  };
}