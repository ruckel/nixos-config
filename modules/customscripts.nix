{ lib, pkgs, config, ... } :
with lib;
let cfg = config.scripts;
in {
  options.scripts = {
    enable = mkEnableOption "DESCRIPTION";

    };

  config = lib.mkIf cfg.enable rec {
    environment.localBinInPath = true;
    environment.etc."bashrc".text = ". /etc/custombashscript.sh ";
    environment.etc."custombashscript.sh".source = ../custombashscript.sh;
  };
}
