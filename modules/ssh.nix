{ lib, pkgs, config, ... } :
with lib;
let
  cfg = config.ssh;
  thewhole = import ./shebang.nix;
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

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user}.openssh.authorizedKeys.keys = cfg.keys;
    environment.systemPackages = with pkgs; [
      x11vnc
      tigervnc
      scrcpy
      vncdo
    ];
    services.openssh = {
      enable = true;
      ports = cfg.ports;
      openFirewall = true;
      settings = {
        PasswordAuthentication = cfg.pwauth;
        X11Forwarding = cfg.x11fw;
      };
    };
    networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 5900 ];# [vnc]
    allowedUDPPorts = [ 5900 ];
    };
    services.fail2ban = {
      enable = true;
      #TODO: Expand fail2ban
    };
    environment.etc."xprofile2".text = lib.mkIf cfg.vncbg ''${args.thewhole.shebang}
x11vnc -forever -noxdamage  -passwdfile ~/.vnc/passwd &
'';
  };
}