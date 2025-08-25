{ lib, config, pkgs, ...}:
let cfg = config.gnomeWM;
  pkgsVersion = pkgs.lib.version or "0.0";
  useNewGnomePath = lib.versionAtLeast pkgsVersion "25.11";
in {
  options = {
    gnomeWM.enable = lib.mkEnableOption "Enable Module";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    /*(lib.mkIf useNewGnomePath {
      services.desktopManager.gnome.enable = true; 
    })*/
    (/*lib.mkIf (!useNewGnomePath)*/ {
      services.xserver.desktopManager.gnome.enable = true;
    })
    ({ environment.variables = {
        GTK_THEME = "Adwaita:dark";
    };})

    { programs.gnome-terminal.enable = false; }
    { environment.systemPackages = with pkgs; [
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
    ]; }
  ]);
}
