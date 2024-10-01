{ lib, pkgs, config, ... } :
with lib;
let cfg = config.qemu;
in {
  options.qemu = {
    enable = mkEnableOption "Virtual machine hosting config";

    };

  config = lib.mkIf cfg.enable {

    programs.virt-manager.enable = true;
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}