{ lib, pkgs, config, userName, ... } : with lib; let
  cfg = config.xscreensaver;
in {
  options.xscreensaver = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}
    enable = mkEnableOption "customizable screensaver daemon";
    pam = mkEnableOption "enable pam service screen lock";
    symlinks = mkOption {
      type = with types; listOf str;
      description = "List of directories to be symlinked in `/run/current-system/sw`";
      default = [ "/home/${cfg.user}/.xscreensaver" ];
    };
    user = mkOption {
      default = userName;
      description = "username to use";
      type = types.str;
     };
   };

  config = mkIf cfg.enable (mkMerge [
    ( /* static config */ {
      environment.pathsToLink = cfg.symlinks;
      services.xscreensaver.enable = true;
      environment.systemPackages = with pkgs; [ xscreensaver ];
    })
    ( {
        security.pam.services.xscreensaver.enable = mkIf cfg.pam true;
    })
   ]);
}
