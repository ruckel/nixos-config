{ lib, config, ... }:
with lib;
let cfg = config.xprofile;
in
{

  options.xprofile = {
    enable = mkEnableOption "DESCRIPTION";
    user = mkOption { default = "user";
      type = types.str;
    };
    };


  config = lib.mkIf cfg.enable {
  environment.etc."xprofile".text = ''
    #!/bin/sh
    runDunst(){
    dunst &
    }
    if [ -z _XPROFILE_SOURCED ]; then
      export _XPROFILE_SOURCED=True
      . /etc/xprofile2 &
      #if [ $DESKTOP_SESSION != "gnome" ];then runDunst ;fi
      toastify send -a 'xserver' -t 1000 -u normal 'loaded' '.xprofile'
    else
      echo already sourced
    fi
  '';
  environment.etc."xprofile2".text = ''
    . /home/${cfg.user}/xautostart &

  '';
  };
}
