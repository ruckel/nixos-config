{ lib, config, pkgs, ... }:
let cfg = config.pythonconf;
in
{
  options.pythonconf.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      python313Full
      python39Full
    ];
  };
}