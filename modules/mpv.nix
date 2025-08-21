{ lib, pkgs, config, ... } :
with lib;
let cfg = config.mpv;
in {
  options.mpv = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}
    enable = mkEnableOption "DESCRIPTION";
   };

  config = mkIf cfg.enable (mkMerge [
    ({ # static config
      environment = {
        systemPackages = with pkgs; [ mpv ];
        etc = {
          "mpv/input.conf" = { 
            source = "../configfiles/mpv/input.conf";
            mode = "0444"; 
          };
          "mpv/mpv.conf" = {
            source = "../configfiles/mpv/mpv.conf";
            mode = "0444"; 
          };
          "mpv/osc_always_on.lua" = {
            source = "../configfiles/mpv/osc_always_on.lua";
            mode = "0444"; 
          };
          "mpv/cript-opts/osc.conf" = {
            source = "../configfiles/mpv/script-opts/osc.conf";
            mode = "0444"; 
          };
          "mpv/scripts/toggle_osc_visibility.lua" = {
            source = "../configfiles/mpv/scripts/toggle_osc_visibility.lua";
            mode = "0444"; 
          };
        };
      };
    })
   ]);
}
