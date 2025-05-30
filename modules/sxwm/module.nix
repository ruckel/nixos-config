{ config, lib, pkgs, ... }:
# github.com/uint23/sxwm
#with lib;

{
  options.sxwm.enable = lib.mkEnableOption "SXWM window manager";

  config = lib.mkIf config.sxwm.enable {
    environment.systemPackages = with pkgs; [
      xorg.libX11
      xorg.libXinerama
      libgcc
      gnumake
    ];
  };
}
