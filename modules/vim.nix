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
  environment.systemPackages = with pkgs; [((vim_configurable.override {}).customize{
    name = "vim";
    vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
      start = [ vim-nix vim-lastplace ];
      opt = [];
    };
    vimrcConfig.customRC = builtins.readFile ./vimrc;
    /*vimrcConfig.customRC = ''
      syntax on
      set expandtab               "space instead of tabs
      set shiftwidth=2
      set tabstop=2
      set number
      "set ignorecase
      set smartcase               "ignores case unless search contains uppercase letters

      map <F10> :set number!<CR>  "! for toggle, nonumber for off
      map <F9> :set rnu!<CR>

      noremap <leader>y "+y
      noremap <leader>p "+p

      set foldmethod=indent
      nnoremap <space> za         " toggle folds with spacebar
      highlight Folded ctermbg=17
      highlight Folded ctermfg=14
     '';
    */
  })];
};
}
