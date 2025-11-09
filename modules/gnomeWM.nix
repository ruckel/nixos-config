{ lib, config, pkgs, ...}: with lib;
let cfg = config.gnome;
  pkgsVersion = pkgs.lib.version or "0.0";
in {
  options.gnome.enable = mkEnableOption "Enable Module";
  config = mkMerge [
    ( mkIf cfg.enable {
      services = if (versionAtLeast pkgsVersion "25.06")
        then ({ desktopManager.gnome.enable = true; })
        else ({ xserver.desktopManager.gnome.enable = true; })
      ;
      print.this = if (versionAtLeast pkgsVersion "25.06") then ["gnome 25.11"] else ["gnome 25.05"];
    })
    ( mkIf (isString config.x.autologin && config.x.dm == "gdm") {
      print.this = [ "applying gdm auto start fix" ];
      # fix: github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
      systemd.services = mkIf (
        (config.x.defaultSession == "gnome" || config.x.defaultSession ==  "gnome-xorg")
      ) {
        "getty@tty1".enable =  false;
        "autovt@tty1".enable =  false;
      };
    })
    ( mkIf cfg.enable {
      environment.variables.GTK_THEME = "Adwaita:dark";
      programs.gnome-terminal.enable = false;
      environment.systemPackages = with pkgs; [
        gnome-browser-connector
        dconf-editor
        gnome-tweaks
        gnomeExtensions.allow-locked-remote-desktop
        gnomeExtensions.appindicator
        gnomeExtensions.arc-menu
        gnomeExtensions.awesome-tiles
        gnomeExtensions.blur-my-shell
        gnomeExtensions.burn-my-windows
        gnomeExtensions.dash-to-dock
        #gnomeExtensions.dash-to-dock-toggle
        #gnomeExtensions.dash-to-plank
        gnomeExtensions.desktop-clock
        gnomeExtensions.do-not-disturb-while-screen-sharing-or-recording
        gnomeExtensions.fuzzy-clock-3
        gnomeExtensions.grand-theft-focus
        #gnomeExtensions.gsconnect
        gnomeExtensions.just-perfection
        gnomeExtensions.launcher
        gnomeExtensions.mock-tray
        gnomeExtensions.notification-counter
        gnomeExtensions.notifications-alert-on-user-menu
        gnomeExtensions.open-bar
        gnomeExtensions.peek-top-bar-on-fullscreen
        gnomeExtensions.quick-text
        gnomeExtensions.sleep-through-notifications
        gnomeExtensions.space-bar
        gnomeExtensions.system-monitor
        gnomeExtensions.task-widget
        gnomeExtensions.todotxt
        gnomeExtensions.tray-icons-reloaded
        gnomeExtensions.volume-scroller-2
        gnomeExtensions.window-title-is-back
      ];
    })
  ];
}
