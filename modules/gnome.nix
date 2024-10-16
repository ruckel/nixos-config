{ lib, config, pkgs, ...}:
let cfg = config.gnome;
in {
  options = {
    gnome.enable = lib.mkEnableOption "Enable Module";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.desktopManager.gnome.enable = true;
    systemd.services = { # fix: github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
    networking.firewall = {
      allowedTCPPortRanges = [{ from = 1714; to = 1764; }];#gsconnect
      allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
    };
    environment.systemPackages = with pkgs; [
      gnome-browser-connector
      dconf-editor
      (gnome.withExtension (subpkgs: with subpkgs; [
        allow-locked-remote-desktop
        appindicator
        arc-menu
        awesome-tiles
        blur-my-shell
        burn-my-windows
        dash-to-dock
        dash-to-dock-toggle
        dash-to-plank
        desktop-clock
        do-not-disturb-while-screen-sharing-or-recording
        fuzzy-clock-2
        grand-theft-focus
        gsconnect
        just-perfection
        launcher
        mock-tray
        notification-counter
        notifications-alert-on-user-menu
        open-bar
        peek-top-bar-on-fullscreen
        quick-text
        sleep-through-notifications
        space-bar
        system-monitor
        task-widget
        todotxt
        tray-icons-reloaded
        volume-scroller-2
        window-title-is-back
      ]))
    ];
  };
}