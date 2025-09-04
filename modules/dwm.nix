{ lib, config, pkgs, vars, ... } :
with lib;
let
  cfg = config.dwm;
in {
  options.dwm.enable  = mkEnableOption "";
  options.dwm = {
    user = mkOption { default = vars.username-admin;
      type = types.str;
    };
    fakefullscreen    = mkEnableOption "";
    allmonitorsstatus = mkEnableOption "";
    activemonitor     = mkEnableOption "";
    noborder          = mkEnableOption "";
    warp              = mkEnableOption "";
    tilewide          = mkEnableOption "";
    focusonclick      = mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dmenu networkmanager_dmenu ];
    programs.slock.enable = true;
    #services.dwm-status.enable = true;
    #services.dwm-status.order = [ "audio" "backlight" "battery" "cpu_load" "network" "time" ];
    services.xserver.windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs rec {
        #src = ~/dwmorg;
        #src = /home/korv/dwm;#TODO dynamic
        src = /home/${cfg.user}/dwm-conf;
        patches = [
          # fakefullscreen
          (pkgs.fetchpatch {
            url = "https://dwm.suckless.org/patches/fakefullscreen/dwm-fakefullscreen-20210714-138b405.diff";
            hash = "sha256-7AHooplO1c/W4/Npyl8G3drG0bA34q4DjATjD+JcSzI=";})
          #  statusallmons
          (pkgs.fetchpatch {
            url = "https://dwm.suckless.org/patches/statusallmons/dwm-statusallmons-6.2.diff";
            hash = "sha256-AdngAZTKzICfwAx66sOdWD3IdsoJN8UW8eXa/o+X5/4=";})
          # activemonitor
          (pkgs.fetchpatch {
            url = "https://dwm.suckless.org/patches/activemonitor/dwm-activemonitor-20230825-e81f17d.diff";
            hash = "sha256-MEF/vSN3saZlvL4b26mp/7XyKG3Lp0FD0vTYPULuQXA=";})
          # noborder
          (pkgs.fetchpatch {
            url = "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
            hash = "sha256-CrKItgReKz3G0mEPYiqCHW3xHl6A3oZ0YiQ4oI9KXSw=";})
          # tilewide
          (pkgs.fetchpatch {
            url = "https://dwm.suckless.org/patches/tilewide/dwm-tilewide-6.4.diff";
            hash = "sha256-l8QDEb8X32LlnGpidaE4xKyd0JmT8+Oodi5qVXg1ol4=";})
          #(pkgs.fetchpatch {
          #  url = "https://gist.githubusercontent.com/ruckel/5241adaefb25034d8f43ace2d3b6e320/raw/bf4306cf9d691ee4f6473f9c91bacebc0aabbcf2/korv.diff";
          #  hash = "sha256-PxSmKuBDFQRgp6qyBjpEKMaBV7Kte/owb65mMxqrHr0=";})
        #  (pkgs.fetchpatch {
        #    url = "https://dwm.suckless.org/patches/centretitle/dwm-centretitle-20200907-61bb8b2.diff";
        #    hash = "sha256-1SSsJaIq1WjAfrz5fiWg+kHs7kHNj3Ie9ls6E834n9c=";
        #  })
        #  (pkgs.fetchpatch {
        #    url = "https://dwm.suckless.org/patches/preserveonrestart/dwm-preserveonrestart-6.3.diff";
        #    hash = "sha256-zgwTCgD3YE+2K4BF6Em+qkM1Gax5vOZfeuWa6zXx8cE=";
        #  })
         #(pkgs.fetchpatch { url = "https://dwm.suckless.org/patches/systray/dwm-systray-20230922-9f88553.diff";
         #  hash = "sha256-Kh1aP1xgZAREjTy7Xz48YBo3rhrJngspUYwBU2Gyw7k=";})
         #(pkgs.fetchpatch { url = "https://dwm.suckless.org/patches/defaulttransparency/dwm-defaulttransparency-r1521.diff";
         #  hash = "sha256-K4UlNVs9y2sAyJFAJhdGHwmBUltWau+bKg3YwXv0350=";})
         #(pkgs.fetchpatch { url = "https://dwm.suckless.org/patches/warp/dwm-warp-6.4.diff";
         #  hash = "sha256-8z41ld47/2WHNJi8JKQNw76umCtD01OUQKSr/fehfLw=";})
         #(pkgs.fetchpatch { url = "https://dwm.suckless.org/patches/focusonclick/dwm-focusonclick-20200110-61bb8b2.diff";
         #  hash = "sha256-FDDBIXbUCEuVLaot3ju8yyqMWqrfCMGcVhV1kmKKusM=";})
#              (pkgs.fetchpatch {
#                url = "https://tools.suckless.org/dmenu/patches/navhistory/dmenu-navhistory-5.0.diff";
#                hash = "sha256-zBADNWotwgt2ur0kf0Dk/Jiw/JcD+nxOQuzZsWJd5Jo=";
#              })
#              (pkgs.fetchpatch {
#                url = "https://dwm.suckless.org/patches/centeredwindowname/dwm-centeredwindowname-20200723-f035e1e.diff";
#                hash = "sha256-oL8VrdqVpJ9yw+yDFpKdr17mvIJjQEYiLYv5DEaLUug=";
#              })
#              (pkgs.fetchpatch {
#                url = "https://dwm.suckless.org/patches/clientopacity/dwm-clientopacity-6.4.diff";
#                hash = "sha256-Q7mUN+jJMVKHL3Nd1zTpTUmEcv3H1DBSNezaeXCJpaM=";
#              })
          #./path/to/local.patch
         #(pkgs.fetchpatch { url = "";
         #  hash = "";})
        ];
        # Make sure you include whatever dependencies the fork needs to build properly!
        # buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
      # If you want it to be always up to date use fetchTarball instead of fetchFromGitHub
      # src = builtins.fetchTarball {
      #   url = "https://www.umaxx.net/dl/dstat-0.8.tar.gz";     # "https://github.com/x/z/archive/master.tar.gz";
      # };
      };
    };
    environment.etc."xprofile".text = ''
    if [ $DESKTOP_SESSION == "none+dwm" ]; then
      echo "" > ~/dwmbar.txt
      ~/.fswebbg
      ~/dwm/dwmbar.sh &
      syncthing &
    fi
    '';
  };
}
