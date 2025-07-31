{ lib, pkgs, config, ... } :
with lib;
let cfg = config.kde;
in {
  options.kde = {
    enable = mkEnableOption "DESCRIPTION";

    user = mkOption { default = "user";
      type = types.str;
    };
    };

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
  };
}
