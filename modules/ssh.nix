{ lib, pkgs, config, ... } :
with lib;
let args = {
  cfg = config.ssh;
  vars = import ../vars.nix;
};
in {
  options.ssh = {
    enable = mkEnableOption "custom ssh conf";
    ports = mkOption {
      type = with types; listOf int;
      default = args.vars.ports;
    };
    user = mkOption {
      type = with types; uniq str;
      default = args.vars.user;
    };
    keys = mkOption {
      type = with types; listOf str;
      default = args.vars.keys;
    };
    pwauth = mkOption {
      type = with types; nullOr bool;
      default = false;
      description = "enable password authentication";
    };
    x11fw = mkOption {
      type = with types; nullOr bool;
      default = true;
      description = "enable x11 forwarding";
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
  };
}