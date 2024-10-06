{ lib, config, pkgs, ... } : 
with lib;
let args = {
  cfg = config.dwm;
};
in {
  options.dwm.enable = mkEnableOption "";

  config = lib.mkIf args.cfg.enable {
    services.xserver.windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs rec { 
        src = /home/user/dwm;
        #src = /etc/nixos/dwm;
        # fetchFromGitHub {
        #   owner = "hollystandring";   # x
        #   repo = "dwm-bar";           # z
        #   rev = "";                   # 8ab3d03681479263a11b05f7f1b53157f61e8c3b
        #   sha256 = "1vz70wh68kgazxy6wympifaq05cg65flfc9jr7q1apfa6spq4274";
        # }
        patches = [
          #./path/to/local.patch
          (pkgs.fetchpatch { url = "https://dwm.suckless.org/patches/fakefullscreen/dwm-fakefullscreen-20210714-138b405.diff";
            hash = "sha256-7AHooplO1c/W4/Npyl8G3drG0bA34q4DjATjD+JcSzI=";})
          (pkgs.fetchpatch { url = "https://dwm.suckless.org/patches/statusallmons/dwm-statusallmons-6.2.diff";
            hash = "sha256-AdngAZTKzICfwAx66sOdWD3IdsoJN8UW8eXa/o+X5/4=";})
          (pkgs.fetchpatch { url = "https://dwm.suckless.org/patches/activemonitor/dwm-activemonitor-20230825-e81f17d.diff";
            hash = "sha256-MEF/vSN3saZlvL4b26mp/7XyKG3Lp0FD0vTYPULuQXA=";})
          (pkgs.fetchpatch { url = "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
            hash = "sha256-CrKItgReKz3G0mEPYiqCHW3xHl6A3oZ0YiQ4oI9KXSw=";})
         #(pkgs.fetchpatch { url = "https://dwm.suckless.org/patches/warp/dwm-warp-6.4.diff";
         #  hash = "sha256-8z41ld47/2WHNJi8JKQNw76umCtD01OUQKSr/fehfLw=";})
          (pkgs.fetchpatch { url = "https://dwm.suckless.org/patches/tilewide/dwm-tilewide-6.4.diff";
            hash = "sha256-l8QDEb8X32LlnGpidaE4xKyd0JmT8+Oodi5qVXg1ol4=";})
         #(pkgs.fetchpatch { url = "https://dwm.suckless.org/patches/focusonclick/dwm-focusonclick-20200110-61bb8b2.diff";
         #  hash = "sha256-FDDBIXbUCEuVLaot3ju8yyqMWqrfCMGcVhV1kmKKusM=";})
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
  };
}
