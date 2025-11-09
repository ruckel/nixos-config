{ lib, config, pkgs, ... }: with lib;
let cfg = config.x;
  pkgsVersion = pkgs.lib.version or "0.0";
in {
  imports = [
#    (mkAliasOptionModule  [ "services" "displayManager" "gdm" ] [ "services" "xserver" "displayManager" "gdm" ])
  ];
  options.x = {
    gdm = {
      enable = mkOption {
        default = true;
        type = types.bool;
      };
      wayland = mkOption {
        default = false;
        type = types.bool;
      };
      debug = mkEnableOption "Enable debugging messages in GDM";
      banner = mkOption {
        description = "Optional message to display on the login screen";
        default = null;
        type = with types; nullOr lines;
      };
      autoSuspend = mkEnableOption "suspend on greeter screen";
      autoLogin.delay = mkOption {
        default = 0;
        type = types.int;
      };
     };
    opt1 = mkEnableOption "";
    opt2 = mkEnableOption "";
    dm-no-autorun = mkEnableOption "Start manually with #systemctl start display-manager.service";
    dm = mkOption {
      description = ''
        Program that manages X server and provides a gui login prompt.
        null defaults to lightdm.
       '';
      default = "gdm";
      type = with types; enum [
        null
        "lightdm"
        "startx"
        "gdm"
        "sddm"
        # "systemd"
        # "lemurs"
        # "ly"
        # "sx"
        # "xpra"
       ];
    };
    autologin = mkOption {
      description = ''
        Username to autologin during boot.
        null deactivates autologin.
       '';
      default = null;
      type = with types; nullOr str;
     };
    defaultSession = mkOption {
      description = ''
        Pre-selected dm/wm in the greeter session chooser.
        Only effective for GDM, LightDM and SDDM,
        on which it will also be used as a session for auto-login.
        Set to empty string "" to get available options during eval.
      '';
      default = "gnome-xorg";
      type = with types; enum [
        null
        ""
        "gnome"
        "gnome-xorg"
        "none+dwm"
        "xfce"
      ];
    };
    wm = { /* Window / desktop manager. Desktop gui */
      gnome = mkOption {
        default = true;
        type = types.bool;
       };
      dwm = mkEnableOption "./dwm.nix";
      hyprland = mkEnableOption "";
      kodi = mkEnableOption "";
      sxwm = mkEnableOption "";
      xfce = mkEnableOption "";
    };
  };

  config = (mkMerge [
    ({ #static config
      print.this = [
#        "xserver: " "def=${if (cfg.defaultSession == null) then "null" else cfg.defaultSession} "
        /*"dm=${cfg.dm} "
        "gnome=${if cfg.wm.gnome then "true" else "false"} "
        "dwm=${if cfg.wm.dwm then ''true'' else ''false''} "
        "hyprland=${if cfg.wm.hyprland then ''true'' else ''false''} "
        "kodi=${if cfg.wm.kodi then ''true'' else ''false''} "
        "sxwm=${if cfg.wm.sxwm then ''true'' else ''false''} "*/
#        "autologin=${if (cfg.autologin == null) then "null" else cfg.autologin}"
      ];
      services.xserver = {
        enable = true;
        autorun = true;
      };
    })
    ( mkIf (cfg.dm == "gdm") {
      services = if ( versionAtLeast pkgsVersion "25.06")
        then ({ displayManager.gdm = cfg.gdm; })
        else ({ xserver.displayManager.gdm = cfg.gdm; })
      ;
    })
    ({
      services.xserver.displayManager.startx = mkIf (cfg.dm == "startx") {
        enable = true;
        generateScript = true;
        extraCommands = ''
            xrdb -load .Xresources
            xsetroot -solid '#666661'
            xsetroot -cursor_name left_ptr
            dwm &
        '';
      };
    })
    ({
     services.displayManager.defaultSession = cfg.defaultSession;
      services.displayManager.autoLogin = mkIf (cfg.autologin != null) {
        enable = true;
        user = cfg.autologin;
      };
    })
    ({
#      sxwm.enable = mkIf cfg.wm.sxwm true;
      dwm.enable = mkIf cfg.wm.dwm true;
      services.xserver.desktopManager.kodi.enable = mkIf cfg.wm.kodi true;
      hyprland.enable = mkIf cfg.wm.hyprland true;
      gnome.enable = mkIf cfg.wm.gnome true;
    })
    ( mkIf cfg.wm.xfce {
      services.xserver.desktopManager.xfce.enable = true;
      services.picom = {
        enable = true;
        fade = true;
        inactiveOpacity = 1;
        shadow = true;
        fadeDelta = 4;
        shadowExclude = [
          "window_type *= 'menu'"
          "name ~= 'Firefox$'"
          "focused = 1"
         ];
       };
     })
    ({ /* Make sure Gnome's infectious keyring daemon stays deactivated */
      services.gnome.gnome-keyring.enable = lib.mkForce false;
      security.pam.services.gdm.enableGnomeKeyring = lib.mkForce false;
    })
   ]);
}
