{ lib, pkgs, config, ... } :
with lib;
let
  cfg = config.docker;
in
{
  options.docker = {
    enable  = mkEnableOption "experimental";
    user    = mkOption {
      default = "user";
      type    = types.str;
    };
    smp    = mkOption {
      default = true;
      type    = types.bool;
    };
    xftp   = mkOption {
      default = true;
      type    = types.bool;
    };
  };


  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.${cfg.user}.extraGroups = [ "docker" ];

    virtualisation.oci-containers.containers.smp = lib.mkIf cfg.smp {
      image = "simplexchat/smp-server";
      ports = [ "5223:5223" ];
      cmd = [''-e "ADDR=smp.korv.lol" \
        -p 5223:5223 \
        -v $HOME/simplex/smp/config:/etc/opt/simplex:z \
        -v $HOME/simplex/smp/logs:/var/opt/simplex:z
        ''];
      volumes = [
      #"/path/on/host:/home/${cfg.user}/simplex/smp/config:/etc/opt/simplex:z"
      #"/path/on/host:/home/${cfg.user}/simplex/smp/logs:/var/opt/simplex:z"
      ];
    };
    virtualisation.oci-containers.containers.xftp = lib.mkIf cfg.xftp {
      image = "simplexchat/xftp-server";
      ports = [ "444:444" ];
      cmd = [''\
        -e "ADDR=xftp.korv.lol" \
        -e "QUOTA=20G" \
        -p 444:444 \
        -v $HOME/simplex/xftp/config:/etc/opt/simplex-xftp:z \
        -v $HOME/simplex/xftp/logs:/var/opt/simplex-xftp:z \
        -v $HOME/simplex/xftp/files:/srv/xftp:z \
        ''];
      volumes = [
      # "/path/on/host:/home/${cfg.user}/simplex/smp/config:/etc/opt/simplex-xftp:z"
      # "/path/on/host:/home/${cfg.user}/simplex/smp/logs:/var/opt/simplex-xftp:z"
      # "/path/on/host:/home/${cfg.user}/simplex/xftp/files:/srv/xftp:z"
      ];
    };
  };
}
#docker run
#-e "ADDR=smp.korv.lol"
#-p 5223:5223
#-v $HOME/simplex/smp/config:/etc/opt/simplex:z
#-v $HOME/simplex/smp/logs:/var/opt/simplex:z
#simplexchat/smp-server:latest
#docker run -d \
#-e "ADDR=xftp.kevindybeck.com" \
#-e "QUOTA=20G" \
#-p 444:444 \
#-v $HOME/simplex/xftp/config:/etc/opt/simplex-xftp:z \
#-v $HOME/simplex/xftp/logs:/var/opt/simplex-xftp:z \
#-v $HOME/simplex/xftp/files:/srv/xftp:z \
#simplexchat/xftp-server:latest
