{ lib, pkgs, config, ... } :
with lib;
let cfg = config.scripts;
in
# region
{
  options.scripts = {
    enable = mkEnableOption "DESCRIPTION";

    };

  config = lib.mkIf cfg.enable rec {
    environment.localBinInPath = true;
  };
}
# endregion