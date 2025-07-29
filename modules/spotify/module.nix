{ config, lib, pkgs, specialArgs, ... } :
with lib;
let cfg = config.spotify;
in {
  options.spotify = {
    enableServices  = mkEnableOption "spotifyd as service";
    enableEtcFile   = mkEnableOption "test specialArgs";
    multiPackages   = mkEnableOption "install many different clients willy nilly";
  };
  config = (mkMerge [
    ({
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
      environment.systemPackages = with pkgs; [ spotify spotify-tray ];
    })
    (mkIf cfg.enableServices { services = {
      spotifyd = { 
        enable    = true;
        #settings = {};
        #config   = {};
      }; 
    };})
    (mkIf cfg.enableEtcFile { environment.etc."hello-user".text = ''
      Hello ${specialArgs.user or "unknown"}!
      On system ${specialArgs.system or "unknown"}.
    ''; })
    (mkIf cfg.multiPackages { environment.systemPackages = with pkgs; [
      spotifywm 
      spotify-player
      spotify-qt
      spotify-cli-linux
    ]; })
  ]);
}
