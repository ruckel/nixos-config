{ lib, pkgs, config, ... } :
with lib;
let cfg = config.systemdconf;
in {
  options.systemdconf = {
    enable = mkEnableOption "DESCRIPTION";

    enableLockOnBoot = mkEnableOption "descripting description";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services = {
      lock-on-boot = lib.mkIf cfg.enableLockOnBoot {
        enable = true;
        after = [ "multi-user.target" "gdm.service" "pipewire-linking.service" ];
        path = [ pkgs.xdg-utils ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''/home/${vars.user}/scripts/lock.sh''; #TODO: Define lock.sh
          #User = vars.user;
          #Group = "users";
        };
        wantedBy = [ "pipewire-linking.service" ];
      };
    };
  };
}