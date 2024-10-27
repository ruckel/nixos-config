{ lib, pkgs, config, ... } :
with lib;
let cfg = config.kanata;
in {
  options.kanata = {
    enable = mkEnableOption "DESCRIPTION";

    user = mkOption { default = "user";
      type = types.str;
    };
    };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = [ "uinput" ];
    services.kanata = {
      enable = true;
      keyboards.korvkb = {
        config = ''
          (defsrc
            caps)

          (deflayermap (default-layer)
            ;; tap caps lock as caps lock, hold caps lock as left control
            caps (tap-hold 100 100 esc lctl))
        '';

      };

    };
  };
}