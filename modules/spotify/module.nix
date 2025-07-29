{ config, lib, pkgs, ... }:
# module.nix
{
  options = {
    services.spotify.enable = lib.mkEnableOption "Enable Spotify desktop app";
  };

  config = /*lib.mkIf config.services.spotify.enable*/ {
    environment.systemPackages = with pkgs; [ spotify ];
  };
}
