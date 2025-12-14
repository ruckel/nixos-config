{ lib, pkgs, config, ... } : with lib; let
  cfg = config.userServices;
in {
  options.userServices = {
    enable = mkEnableOption "DESCRIPTION";
    lockScreenOnBoot = mkEnableOption "lock screen with i3lock on boot";
    dunst = mkEnableOption "notification daemon";
  };

  config = mkIf cfg.enable ( mkMerge [
    ( mkIf cfg.lockScreenOnBoot {
      programs.i3lock.enable = true;
      systemd.user.services.lock-screen-on-boot = {
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
     })
    ( mkIf cfg.dunst {
      systemd.user.services.dunst = {
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
     })
  ]);
}
