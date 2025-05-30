{ config, lib, pkgs, ... }:
# github.com/uint23/sxwm
{
  options.sxwm.enable = mkEnableOption "SXWM window manager";

  config = mkIf config.sxwm.enable {
    environment.systemPackages = with pkgs; [
      xorg.libX11
      xorg.libXinerama
      libgcc
      gnumake
    ];
  };
}
