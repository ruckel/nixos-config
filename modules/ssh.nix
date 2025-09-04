{ lib, pkgs, config, userName, hostName, vars, ... } : with lib;
let
  cfg = config.ssh;
  thewhole = import ./shebang.nix;
  pkgsVersion = pkgs.lib.version or "0.0";
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
    ({
      fail2ban.enable = true; # ./fail2ban.nix
      services.openssh = {
        enable = true;
        ports = mkIf (isList vars.ssh.ports) vars.ssh.ports;
        openFirewall = true;
        settings.X11Forwarding = cfg.x11fw;
      };
      services.openssh.settings = {
          PasswordAuthentication = if cfg.auth.pw then true else false;
          KbdInteractiveAuthentication = if cfg.auth.kbd then true else false;
      };
#      print.this = [ "ssh: root: ${toString cfg.auth.root}" ];
    })
    ( mkIf (isBool cfg.auth.root) {
      services.openssh.settings.PermitRootLogin = if cfg.auth.root then  "prohibit-password" else "no";
    })
    ( mkIf (isString cfg.auth.root) {
      services.openssh.settings.PermitRootLogin = cfg.auth.root;
    })
#    ( mkIf (hostName == "burk") {
#      print.this = [ "ssh:" "pkgs vers: ${pkgsVersion}, hname: ${hostName}" ];
#      services = mkIf (versionAtLeast pkgsVersion "25.06")
#       /* then */ ({ gnome.gcr-ssh-agent.enable = false; })
#        else ({ xserver.desktopManager.gnome.enable = true; })
#      ;
#    })
    ({
      programs.ssh.setXAuthLocation = true;
      services.openssh.banner = ''ass ass ey''; # Message to display to the remote user before authentication is allowed
#      programs.ssh.startAgent = true; # remembers private keys. starts at boot. Use ssh-add to add a key to the agent
      users.users.${userName}.openssh.authorizedKeys.keyFiles = [
          config.sops.secrets.pubkey-burk.path
          config.sops.secrets.pubkey-labb.path
          config.sops.secrets.pubkey-tele.path
          config.sops.secrets.pubkey-dell.path
      ];
      programs.ssh.knownHostsFiles = [
          config.sops.secrets.hostkey-burk.path
          config.sops.secrets.hostkey-labb.path
          config.sops.secrets.hostkey-tele.path
          config.sops.secrets.hostkey-dell.path
      ];
      services.openssh.extraConfig = /* sshd_config */ ''
          Include /etc/ssh/sshd_config.d/*.conf
      '';
      services.openssh.authorizedKeysInHomedir = true;
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
