{ lib, pkgs, config, ... } :
with lib;
let cfg = config.pcon;
in
{
  options.pcon = {
    enable = mkEnableOption "";
    kde = mkEnableOption "";
    gscon = mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
      allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
    };
    programs.kdeconnect = lib.mkIf cfg.kde {
      enable = true;
    };
    environment = lib.mkIf cfg.gscon {
      systemPackages = with pkgs.gnomeExtensions; [ gsconnect ];
    };
  };
}
