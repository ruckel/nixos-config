{ lib, pkgs, config, ... } :
with lib;
let
  cfg = config.ssh;
  thewhole = import ./shebang.nix;
in {
  options.ssh = {
    enable = mkEnableOption "custom ssh conf";
    user = mkOption { default = "user";
      type = types.str;
    };
    askPass = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
    startAgent = true;
    ports = mkOption { default = [ ];
      type = with types; listOf int;
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
    #programs.ssh.setXAuthLocation = true;
    networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 5900 ];# [vnc]
    allowedUDPPorts = [ 5900 ]; #TODO prots
    };
    services.fail2ban = {
      enable = true;
      #TODO: Expand fail2ban
    };
    environment.etc."xprofile2".text = lib.mkIf cfg.vncbg ''${thewhole.shebang}
x11vnc -forever -noxdamage  -rfbauth ~/.vnc/passwd &
'';
  };
}
