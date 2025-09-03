{ lib, pkgs, config, vars, ... } :
with lib;
let
  cfg = config.ssh;
  thewhole = import ./shebang.nix;
in {
  options.ssh = {
    enable = mkEnableOption "custom ssh conf";
    auth = {
      pw    = mkEnableOption "password";
      kbd   = mkEnableOption "keyboard interactive";
      root = mkOption {
        description = "allow root login";
        default = false;
        type = with types; either bool (enum [
        "yes" "no"
        "prohibit-password"
        "without-password"
        "forced-commands-only"
        ]);
      };
    };
    x11fw = mkOption {
      default = true;
      type = types.bool;
      description = "enable x11 forwarding";
    };
    vnc = {
      enable = mkEnableOption "Graphical remote ssh connection";
      port = mkOption {
        default = 5900;
        type = types.int;
      };
      daemon = mkOption {
        default = true;
        type = types.bool;
        description = "Background VNC server at startup";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
      #programs.ssh.setXAuthLocation = true;
    ({
      fail2ban.enable = true; # ./fail2ban.nix
      services.openssh = {
        enable = true;
        ports = mkIf (isList vars.ssh.ports) vars.ssh.ports;
        openFirewall = true;
        settings.X11Forwarding = cfg.x11fw;
      };
      services.openssh.settings = {
          PasswordAuthentication = mkIf cfg.auth.pw "true";
          KbdInteractiveAuthentication = mkIf cfg.auth.kbd "true";
      };
      print.this = [ "ssh: root: ${toString cfg.auth.root}" ];
    })
    ( mkIf (isBool cfg.auth.root) {
      services.openssh.settings.PermitRootLogin = if cfg.auth.root then "yes" else "no";
    })
    ( mkIf (isString cfg.auth.root) {
      services.openssh.settings.PermitRootLogin = cfg.auth.root;
    })
    ({
#      users.users.${vars.username-admin}.openssh.authorizedKeys.keys = mkIf (isList vars.keys) vars.keys;
      #programs.ssh.knownHostsFiles = ; #todo ssh
      services.openssh = {
        #authorizedKeysFiles
        #authorizedKeysInHomedir = true; #~/.ssh/authorized_keys
      };
    })
    ( mkIf cfg.vnc.enable {
      services.openssh.settings.X11Forwarding = mkForce true;
      environment.systemPackages = with pkgs; [
        x11vnc
        tigervnc
        vncdo
      ];
      networking.firewall = {
        allowedTCPPorts = [ cfg.vnc.port ];
        allowedUDPPorts = [ cfg.vnc.port ];
      };
      environment.etc."xprofile2".text = lib.mkIf cfg.vnc.daemon ''${thewhole.shebang}
        x11vnc -forever -noxdamage  -passwdfile ~/.vnc/passwd &
      '';
    })
  ]);
}
