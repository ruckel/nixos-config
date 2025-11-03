{ lib, pkgs, config, userName, hostName, vars, ... } : with lib;
let
  cfg = config.ssh;
  thewhole = import ./shebang.nix;
  pkgsVersion = pkgs.lib.version or "0.0";
in {
  options.ssh = {
    enable = mkEnableOption "custom ssh conf";
    allowSFTP = mkEnableOption "Allow SFTP, SSHfs etc..";
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
      #fail2ban.enable = true; # ./fail2ban.nix
      services.openssh = {
        enable = true;
        settings.X11Forwarding = cfg.x11fw;
        allowSFTP = true;
      };
      services.openssh.settings = {
          PasswordAuthentication = if cfg.auth.pw then true else false;
          KbdInteractiveAuthentication = if cfg.auth.kbd then true else false;
      };
#      print.this = [ "ssh: root: ${toString cfg.auth.root}" ];
    })
    ( mkIf cfg.allowSFTP {
      services.openssh.allowSFTP = true;
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
      services.openssh.authorizedKeysFiles = [
          config.sops.secrets.pubkey-burk.path
      ];
      services.openssh.extraConfig = ''
          # Added to bottom of sshd_config
          Include /etc/ssh/sshd_config.d/*.conf
      '';
      services.openssh.authorizedKeysInHomedir = true;
    })
    ( mkIf (builtins.pathExists config.sops.secrets.main-pub.path) {
      users.users.${userName}.openssh.authorizedKeys.keyFiles = [ config.sops.secrets.main-pub.path ];
    })
    ( mkIf (builtins.pathExists config.sops.secrets.secure-pub.path) {
      users.users.${userName}.openssh.authorizedKeys.keyFiles = [ config.sops.secrets.secure-pub.path ];
      services.openssh.authorizedKeysFiles = [ config.sops.secrets.secure-pub.path ];
    })
    ( mkIf cfg.vnc.enable {
      networking.firewall = {
        allowedTCPPorts = [ cfg.vnc.port ];
        allowedUDPPorts = [ cfg.vnc.port ];
      };
      environment.etc."xprofile2".text = lib.mkIf cfg.vnc.daemon ''${thewhole.shebang}
        x11vnc -forever -noxdamage  -passwdfile ~/.vnc/passwd &
      '';
    })
    ({
      services.rustdesk-server = {
        enable = true;
        openFirewall = true;  # TCP: [ 21115 21116 21117 21118 21119 ], UDP: 21116
        signal = {
          enable = false;
          extraArgs = [];     # extra commands passed to hbbs process
          relayHosts = [];    # relay server IPs / DNS names of RustDesk relay
        };
        relay = {
          enable = false;
          extraArgs = [];     # extra commands passed to hbbr process
        };
      };
    })
    ({
      services.openssh.settings.X11Forwarding = mkForce true;
      environment.systemPackages = with pkgs; [
        x11vnc tigervnc vncdo
        sshfs # Filesystems over ssh
        sirikali #GUI handler of sshfs / encrypted fs's
        nixos-firewall-tool
      ];
    })
    ({
      systemd.services.sshd-allow-ports = {
        enable = true;
        after = [ "network.target" ];
        wantedBy = [ "default.target" ];
        description = "Allow SSHD ports";
        serviceConfig = {
            Type = "oneshot";
            ExecStart = config.sops.secrets.service.path;
        };
      };
    })
  ]);
}
