{ lib, pkgs, config, ... } :
with lib;
let cfg = config.hyprland;
in {
  options.hyprland = {
    enable = mkEnableOption "DESCRIPTION";
    };

  config = lib.mkIf cfg.enable {
    programs.hyprlock.enable  = true;
    services.hypridle.enable  = true;
    programs.hyprland = {
      enable                  = true;
      #xwayland.enable         = false;
    };
  };
}