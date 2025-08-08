{ lib, pkgs, config, ... } :
  with lib;
  let 
  cfg = config.vim;
in {
  options.vim = {
    enable = mkOption { 
      default = true;
      type = types.bool;
    };
    plugins = mkOption { 
      default = [ vim-nix vim-lastplace ];
      type = with types; listOf package;
    };
    asDefault = mkOption { 
      default = true;
      type = types.bool;
    };
  };
  config = mkIf cfg.enable {
    programs.vim = {
      enable =  true;
      defaultEditor = mkIf cfg.asDefault true;
    };
    environment.variables = mkIf cfg.asDefault { EDITOR = "vim"; };
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
