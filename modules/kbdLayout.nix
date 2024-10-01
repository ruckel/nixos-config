{ lib, pkgs, config, ... } :
with lib;
let cfg = config.kbdLayout;
in {
  options.kbdLayout = {
    enable = mkEnableOption "DESCRIPTION";

    };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      xkb.layout = "korvus";
      displayManager.sessionCommands = "setxkbmap korvus";
      xkb.extraLayouts.korvus = {
        description = "too lazy for a description";
        languages = [ "se" ];
        symbolsFile = ../xkbLayouts/symbols/korvus;
        #keycodesFile = ../xkbLayouts/symbols/korvus-key;
      };

    };
  };
}