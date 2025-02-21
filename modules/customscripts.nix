{ lib, pkgs, config, ... } :
with lib;
let cfg = config.scripts;
in {
  options.scripts = {
    enable = mkEnableOption "DESCRIPTION";

    };

  config = lib.mkIf cfg.enable rec {
    environment.localBinInPath = true;
    environment.etc."bashrc".text = ". /etc/bashaliases ";
    environment.etc."bashaliases".source = ../bash/aliases;
  };
}
