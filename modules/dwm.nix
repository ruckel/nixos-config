{ lib, config, pkgs, userName, ... } : with lib; let
  cfg = config.dwm;
in {
  options.dwm = {
    enable  = mkEnableOption "";
    user = mkOption {
      default = userName;
      type = types.str;
     };
    customPatch = mkOption {
      default = false;
      type = types.bool;
      description = "";
     };
    status = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Pre-made items in status bar";
       };
      order = mkOption {
        default = [ "audio" "backlight" "battery" "cpu_load" "network" "time" ];
        type = with types; listOf str;
        description = "";
       };
     };
    slock = mkOption {
      default = true;
      type = types.bool;
      description = "Screen lock program";
     };
    fakeFullscreen = mkOption {
      default = true;
      type = types.bool;
      description = "Each tile emulates a full monitor, so video players full screens within the tile";
     };
    statusAllMons = mkOption {
      default = true;
      type = types.bool;
      description = "";
     };
    activeMonitor = mkOption {
      default = true;
      type = types.bool;
      description = "";
     };
    noBorder = mkOption {
      default = true;
      type = types.bool;
      description = "";
     };
    warp = mkOption {
      default = true;
      type = types.bool;
      description = "";
     };
    tilewide = mkOption {
      default = true;
      type = types.bool;
      description = "";
     };
    focusOnClick = mkOption {
      default = false;
      type = types.bool;
      description = "";
     };
    systray = mkOption {
      default = false;
      type = types.bool;
      description = "";
     };
    preserveOnRestart = mkOption {
      default = false;
      type = types.bool;
      description = "";
     };
    defaultTransparency = mkOption {
      default = false;
      type = types.bool;
      description = "";
     };
    centreTitle = mkOption {
      default = false;
      type = types.bool;
      description = "";
     };
    dmenuNavhistory = mkOption {
      default = false;
      type = types.bool;
      description = "";
     };
    centeredWindowName = mkOption {
      default = false;
      type = types.bool;
      description = "";
     };
    clientOpacity = mkOption {
      default = false;
      type = types.bool;
      description = "";
     };
   };

  config = mkIf cfg.enable ( mkMerge [
    ( /* general setup*/ {
      environment.systemPackages = with pkgs; [
        dmenu
        networkmanager_dmenu
       ];
      programs.slock.enable = true;
      services.dwm-status.enable = cfg.status.enable;
      services.dwm-status.order = mkIf (cfg.status.enable) cfg.status.order;
      environment.etc."xprofile".text = ''
        if [ $DESKTOP_SESSION == "none+dwm" ]; then
          echo "" > ~/dwmbar.txt
          ~/.fswebbg
          ~/dwm/dwmbar.sh &
          syncthing &
        fi
      '';
     })
    ( /* dwm package specification, patches etc. */ {
      services.xserver.windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.overrideAttrs rec {
            # Make sure you include whatever dependencies the fork needs to build properly!
            # buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
            # If you want it to be always up to date use fetchTarball instead of fetchFromGitHub
            # src = builtins.fetchTarball {
            #   url = "https://www.umaxx.net/dl/dstat-0.8.tar.gz";     # "https://github.com/x/z/archive/master.tar.gz";
            # };
          src = /home/${cfg.user}/dwm-conf;
          patches =
            (     optional cfg.fakeFullscreen [
              (pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/fakefullscreen/dwm-fakefullscreen-20210714-138b405.diff";
                hash = "sha256-7AHooplO1c/W4/Npyl8G3drG0bA34q4DjATjD+JcSzI=";
               })
             ])
            ++ ( optional cfg.statusAllMons [
              ( pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/statusallmons/dwm-statusallmons-6.2.diff";
                hash = "sha256-AdngAZTKzICfwAx66sOdWD3IdsoJN8UW8eXa/o+X5/4=";
               })
             ])
            ++ ( optional cfg.activeMonitor [
              ( pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/activemonitor/dwm-activemonitor-20230825-e81f17d.diff";
                hash = "sha256-MEF/vSN3saZlvL4b26mp/7XyKG3Lp0FD0vTYPULuQXA=";
              })
             ])
            ++ ( optional cfg.noBorder [
              ( pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
                hash = "sha256-CrKItgReKz3G0mEPYiqCHW3xHl6A3oZ0YiQ4oI9KXSw=";
              })
             ])
            ++ ( optional cfg.warp [
              ( pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/warp/dwm-warp-6.4.diff";
                hash = "sha256-8z41ld47/2WHNJi8JKQNw76umCtD01OUQKSr/fehfLw=";
              })
             ])
            ++ ( optional cfg.tilewide [
              ( pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/tilewide/dwm-tilewide-6.4.diff";
                hash = "sha256-l8QDEb8X32LlnGpidaE4xKyd0JmT8+Oodi5qVXg1ol4=";
              })
             ])
            ++ ( optional cfg.focusOnClick [
              ( pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/focusonclick/dwm-focusonclick-20200110-61bb8b2.diff";
                hash = "sha256-FDDBIXbUCEuVLaot3ju8yyqMWqrfCMGcVhV1kmKKusM=";
              })
             ])
            ++ ( optional cfg.systray [
              ( pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/systray/dwm-systray-20230922-9f88553.diff";
                hash = "sha256-Kh1aP1xgZAREjTy7Xz48YBo3rhrJngspUYwBU2Gyw7k=";
              })
             ])
            ++ ( optional cfg.preserveOnRestart  [
              ( pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/preserveonrestart/dwm-preserveonrestart-6.3.diff";
                hash = "sha256-zgwTCgD3YE+2K4BF6Em+qkM1Gax5vOZfeuWa6zXx8cE=";
              })
             ])
            ++ ( optional cfg.defaultTransparency [
              ( pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/defaulttransparency/dwm-defaulttransparency-r1521.diff";
                hash = "sha256-K4UlNVs9y2sAyJFAJhdGHwmBUltWau+bKg3YwXv0350=";
              })
             ])
            ++ ( optional cfg.centreTitle [
              ( pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/centretitle/dwm-centretitle-20200907-61bb8b2.diff";
                hash = "sha256-1SSsJaIq1WjAfrz5fiWg+kHs7kHNj3Ie9ls6E834n9c=";
              })
             ])
            ++ ( optional cfg.dmenuNavhistory [
              ( pkgs.fetchpatch {
                url = "https://tools.suckless.org/dmenu/patches/navhistory/dmenu-navhistory-5.0.diff";
                hash = "sha256-zBADNWotwgt2ur0kf0Dk/Jiw/JcD+nxOQuzZsWJd5Jo=";
              })
             ])
            ++ ( optional cfg.centeredWindowName [
              ( pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/centeredwindowname/dwm-centeredwindowname-20200723-f035e1e.diff";
                hash = "sha256-oL8VrdqVpJ9yw+yDFpKdr17mvIJjQEYiLYv5DEaLUug=";
              })
             ])
            ++ ( optional cfg.clientOpacity [
              ( pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/clientopacity/dwm-clientopacity-6.4.diff";
                hash = "sha256-Q7mUN+jJMVKHL3Nd1zTpTUmEcv3H1DBSNezaeXCJpaM=";
              })
             ])

            ++ ( optional cfg.customPatch [
              ( pkgs.fetchpatch {
                url = "https://gist.githubusercontent.com/ruckel/5241adaefb25034d8f43ace2d3b6e320/raw/bf4306cf9d691ee4f6473f9c91bacebc0aabbcf2/korv.diff";
                hash = "sha256-PxSmKuBDFQRgp6qyBjpEKMaBV7Kte/owb65mMxqrHr0=";
               })
             ])

            ++ ( optional (false) /* example of local patch */ [
              ./path/to/local.patch
             ])
            ++ ( optional (false) /* template with fetchPatch*/ [
              ( pkgs.fetchpatch {
                url = "";
                hash = "";
              })
             ])

           ;
         };
       };
     })
   ]);
}
