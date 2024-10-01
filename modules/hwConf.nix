{ lib, pkgs, config, ... } :
with lib;
let args = {
  cfg = config.hwConf;
  vars = import ../vars.nix;
};
in {
  options.hwConf = {
    enable = mkEnableOption "custom hardware configuration";

  };

  config = lib.mkIf args.cfg.enable {
    system.stateVersion = args.vars.stateVersion;
  };
}