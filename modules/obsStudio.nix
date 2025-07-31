{ lib, pkgs, config, ... } :
with lib;
let cfg = config.obsStudio;
in {
  options.obsStudio = {
    enable = mkEnableOption "obsStudio";
    user = mkOption { default = "user";
      type = types.str;
     };
   };

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ]; # vCam dep
    boot.kernelModules = [ "v4l2loopback" ]; # vCam dep
    boot.extraModprobeConfig = # vCam dep
      ''options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1'';
    security.polkit.enable = true;
    environment.systemPackages = with pkgs; [ obs-studio ];
   };
}
