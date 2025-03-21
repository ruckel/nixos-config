{ lib, pkgs, config, ... } :
with lib;
let cfg = config.tmux;
in {
  options.tmux = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}
    enable = mkEnableOption "tmux";
    strings = mkOption {
      type = with types; nullOr listOf str;
     };
    shortcut = mkOption { default = "q";
       type = types.str;
       description = "key to press after Ctrl for prefix. Def: b";
     };
    term = mkOption { default = "screen-256color";
      description = "Sets $TERM. Def: screen";
      type = types.str;
     };
    newSession = mkOption { default = true;
      description = "autospawn a session if none";
      type = types.bool;
     };
    conf.preplugin = mkOption {
      description = "sets /etc/tmux.conf";
      type = types.lines;
      default = ''
        ##switch pane w/ Alt-arrow
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        ##enable mouse control
        set -g mouse on
       '';
     };
    conf.postplugin = mkOption {
      description = "sets /etc/tmux.conf";
      type = types.lines;
      default = ''

       '';
       /*
       #set-option -g allow-rename off  ##don't rename windows automatically
       */
    };
    plugins = mkOption {
      description = "";
      type = with types; listOf package;
      default = [

       ];
     };
    unsecureSocket = mkEnableOption "Socket under /run. More secure than /tmp, but doesn’t survive user logout";
   };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.unsecureSocket {
      programs.tmux.secureSocket = false;
    })
    ({programs.tmux = {
      enable = true;
      keyMode = "vi"; #"emacs" "vi"
      clock24 = true;
      newSession = true;
      baseIndex = 1;
      shortcut = cfg.shortcut;
      terminal = cfg.term;
      plugins = cfg.plugins;
      extraConfigBeforePlugins = cfg.conf.preplugin;
      extraConfig = cfg.conf.postplugin;
    };})
   ]);
}
