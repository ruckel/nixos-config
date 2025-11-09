{ lib, pkgs, config, ... } :
with lib;
let cfg = config.kodi;
in {
  options.kodi = {
    enable = mkEnableOption "kodi";

    user = mkOption { default = "user";
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
