{ lib, pkgs, config, userName, ... } : with lib; let
  cfg = config.kodi;
in {
  options.kodi = {
    enable = mkEnableOption "kodi";

    user = mkOption {
      default = userName;
      type = types.str;
      };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.kodi.withPackages (kodiPkgs: with kodiPkgs; [ jellyfin ]))
    ];
    networking.firewall = {
      allowedTCPPorts = [ 8080 ];
      allowedUDPPorts = [ 8080 ];
    };
  };
}
