{ lib, pkgs, config, ... } :
with lib;
let cfg = config.vim;
in {
options.vim = {
  enable = mkEnableOption "DESCRIPTION";
  user = mkOption { default = "user";
    type = types.str;
  };
  };
config = mkIf cfg.enable {
 /* vim = { enable = true;
   defaultEditor = true;
   }; */
  environment.variables = { EDITOR = "vim"; };
  environment.systemPackages = with pkgs; [
    ((vim_configurable.override {  }).customize{
      name = "vim";
      # Install plugins for example for syntax highlighting of nix files
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix vim-lastplace ];
        opt = [];
       };
      vimrcConfig.customRC = ''
        set nocompatible
        set backspace=indent,eol,start

        set shiftwidth=2
        set tabstop=2
        set expandtab " Use space characters instead of tabs.

        syntax on

        map <F10> :set number!<CR> "! for toggle, nonumber for off
        map <F9> :set rnu!<CR>
        set number "relativenumber
        noremap <leader>y "+y
        noremap <leader>p "+p
        '';
       }
     )];
 };
}
