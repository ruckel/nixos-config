{ lib, pkgs, config, ... } :
with lib;
let cfg = config.userServices;
in {
  options.userServices = {
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
      dunst = {
        enable = true;
        after = [ "multi-user.target" "gdm.service" ];
        path = [ pkgs.dunst ];
        serviceConfig = {
          Type = "simple";
          ExecStart = ''dunst  --startup_notification''; 
          #User = vars.user;
          #Group = "users";
        };
      };
      xscreensaver = {
        enable = true;
        after = [ "multi-user.target" "gdm.service" ];
        path = [ pkgs.xscreensaver ];
        serviceConfig = {
          Type = "simple";
          ExecStart = ''xscreensaver --no-splash''; 
          #User = vars.user;
          #Group = "users";
        };
      };
    };
  };
}
