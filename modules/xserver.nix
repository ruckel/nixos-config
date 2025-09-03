{ lib, pkgs, config, vars, ... } :
with lib;
let cfg = config.xserver;
in {
  options.xserver = {
    opt1 = mkEnableOption "";
    opt2 = mkEnableOption "";
    displayManager = {
      description = "Program that manages X server and provides a gui login prompt";
      default = "gdm";
      type = with types; nullOr str /*[
        "lightdm"
        "startx"
        "gdm"
        "sddm"
#        "systemd"
#        "lemurs"
#        "ly"
#        "sx"
#        "xpra"
      ]*/;
    };
    autologin = mkOption {
      default = null;
      type = with types; nullOr str;
    };
    defaultSession = mkOption {
      description = "Window / desktop manager. The desktop gui";
      default = "gnome-xorg";
      type = with types; enum [
        null
        "gnome-xorg"
        "none-dwm"
      ];
    };
    windowManager = {
      gnome = mkOption {
        default = true;
        type = types.bool;
      };
      dwm = mkEnableOption "";
      hyprland = mkEnableOption "";
      kodi = mkEnableOption "";
      sxwm = mkEnableOption "";
    };
    strings = mkOption {
      description = "";
      type = with types; nullOr listOf str;
    };
  };

  config = (mkMerge [
    ({ #static config
      services.xserver = {
        enable = true;
        autorun = true;
      };
    })
    ({
      services.xserver.displayManager.startx = mkIf (cfg.displayManager == "startx") {
        enable = true;
        generateScript = true;
        extraCommands = ''
            xrdb -load .Xresources
            xsetroot -solid '#666661'
            xsetroot -cursor_name left_ptr
        '';
      };
      environment.etc."test-dpMan.txt" = /*mkIf (cfg.displayManager == "gdm")*/ {text = /*${cfg.displayManager}*/ " ${vars.username-admin}";};
      services.displayManager.gdm = /*mkIf (cfg.displayManager == "gdm")*/ {
        enable = true;
        wayland = false;
      };
      services.gnome.gnome-keyring.enable = lib.mkForce false;
      security.pam.services.gdm.enableGnomeKeyring = lib.mkForce false;
      systemd.services = mkIf (cfg.displayManager == "gdm") { # fix: github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
        "getty@tty1".enable = mkIf (cfg.autologin != null) false;
        "autovt@tty1".enable = mkIf (cfg.autologin != null) false;
      };
      services.displayManager.defaultSession = cfg.defaultSession;
      services.displayManager.autoLogin = mkIf (cfg.autologin != null) {
        enable = true;
        user = cfg.autologin;
      };
    })
    ({
#       services.xserver.desktopManager.kodi.enable = mkIf cfg.windowManager.kodi true;
      dwm = mkIf cfg.windowManager.dwm {
        enable = true;
        user = "korv"; #todo rm
      };

#      sxwm.enable = mkIf cfg.windowManager.sxwm true;
#      hyprland.enable = mkIf cfg.windowManager.hyprland true;
      gnomeWM.enable = mkIf cfg.windowManager.gnome true;
    })
    ({


    })
    (mkIf cfg.opt1 {

    })
    (mkIf cfg.opt2 {

    })
   ]);
}
