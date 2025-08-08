{ lib, pkgs, config, ... } :
with lib;
let 
cfg = config.vim;
in {
options.vim = {
  enable = mkEnableOption "DESCRIPTION";
  user = mkOption { default = "user";
    type = types.str;
  };
};
config = mkIf cfg.enable {
  environment.variables = { EDITOR = "vim"; };
  environment.systemPackages = with pkgs; [
    ((vim_configurable.override {}).customize{
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix vim-lastplace ];
        opt = [];
      };
      vimrcConfig.customRC = builtins.readFile ./vimrc;
    })
  ];
};
}
