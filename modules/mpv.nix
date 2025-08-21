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
        shellAliases = { mpv = "mpv --config-dir=/etc/mpv/"; };
        etc = {
          "mpv/input.conf" = { 
            source = ../configfiles/mpv/input.conf;
          };
          "mpv/mpv.conf" = {
            source = ../configfiles/mpv/mpv.conf;
          };
          "mpv/osc_always_on.lua" = {
            source = ../configfiles/mpv/osc_always_on.lua;
          };
          "mpv/cript-opts/osc.conf" = {
            source = ../configfiles/mpv/script-opts/osc.conf;
          };
          "mpv/scripts/toggle_osc_visibility.lua" = {
            source = ../configfiles/mpv/scripts/toggle_osc_visibility.lua;
          };
        };
      };
    })
   ]);
}
