{ config, lib, pkgs, ... }:
# github.com/uint23/sxwm
{
  options.sxwm.enable = lib.mkEnableOption "SXWM window manager";
  options.sxwm = {
    user = mkOption { default = "korv";
      type = types.str;
    };
  };

  config = lib.mkIf config.sxwm.enable {
    environment.systemPackages = with pkgs; [
      xorg.libX11
      xorg.libXinerama
      libgcc
      gcc
      gnumake
    ];
   services.xserver.enable = true;
   services.xserver.windowManager.sxwm = {
     enable = true;
     package = pkgs.sxwm.ovverrideAttrs sec {
       src = /home/${cfg.user}/sxwm;
      };
    };
   #programs.xorg.windowManager.sxwm.enable = true;
   #programs.xorg.windowManager.sxwm.extraPackages = with pkgs; [xorg.xmodmap];
  };
}
