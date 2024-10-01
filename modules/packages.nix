{ lib, pkgs, config, ... } :
with lib;
let args = {
  cfg = config.mypkgs;
  textfile = import ../packages.txt
};
in {
  options.mypkgs = {
    enable = mkEnableOption "DESCRIPTION";

    };

  config = {
    programs = {
      bash.vteIntegration = true;
      firefox.enable = true;
      steam.enable = true;
      appimage.binfmt = true;
    };
    environment.systemPackages = with pkgs; [
      args.cfg.textfile
    ];
  };
}