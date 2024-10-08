{ lib, pkgs, config, ... } :
with lib;
let args = {
  cfg = config.ssh;
  vars = import ../vars.nix;
  thewhole = import ./shebang.nix;
};
in {
  options.ssh = {
    enable = mkEnableOption "custom ssh conf";
    ports = mkOption { default = args.vars.ports;
      type = with types; listOf int;
    };
    user = mkOption { default = args.vars.user;
      type = with types; nullOr str;
      description = "which user (singular) to allow ssh connections";
    };
    keys = mkOption { default = args.vars.keys;
      type = with types; listOf str;
      description = "authorization keys";
      };
    pwauth = mkEnableOption "enable password authentication";
    x11fw = mkOption { default = true;
      type = types.bool;
      description = "enable x11 forwarding";
    };
    vncbg = mkOption { default = true;
      type = types.bool;
      description = "Background VNC server at startup";
    };
  };

  config = lib.mkIf args.cfg.enable {
    users.users.${args.cfg.user}.openssh.authorizedKeys.keys = args.cfg.keys;
    services.openssh = {
      enable = true;
      ports = args.cfg.ports;
      openFirewall = true;
      settings = {
        PasswordAuthentication = args.cfg.pwauth;
        X11Forwarding = args.cfg.x11fw;
      };
    };
    services.fail2ban = {
      enable = true;
      #TODO: Expand fail2ban
    };
    environment.etc."xprofile2".text = lib.mkIf args.cfg.vncbg ''${args.thewhole.shebang}
x11vnc -forever -noxdamage  -passwdfile ~/.vnc/passwd &
'';
  };
}