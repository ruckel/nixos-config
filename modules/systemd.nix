{ lib, pkgs, config, ... } :
with lib;
let cfg = config.lockScreenOnBoot;
in {
  options.lockScreenOnBoot = {
    enable = mkEnableOption "DESCRIPTION";
    lockScreenOnBoot = mkEnableOption "lock screen with i3lock on boot";
  };

  config = lib.mkIf cfg.enable {
    programs.i3lock.enable = true;
    systemd.user.services = {
      lock-screen-on-boot = lib.mkIf cfg.lockScreenOnBoot {
        enable = true;
        after = [ "multi-user.target" "gdm.service" "pipewire-linking.service" ];
        path = [ pkgs.xdg-utils ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''i3lock''; 
          #User = vars.user;
          #Group = "users";
        };
        wantedBy = [ "pipewire-linking.service" ];
      };
    };
  };
}
