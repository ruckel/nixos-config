{ lib, pkgs, config, ... } :
with lib;
let cfg = config.tmux;
in {
  options.tmux = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}
    enable = mkEnableOption "tmux";
    strings = mkOption {
      type = with types; 
      nullOr listOf str;
    };
    shortcut = mkOption { 
      description = "key to press after Ctrl for prefix. Def: b";
      default = "q";
      type = types.str;
    };
    term = mkOption { 
      default = "xterm-256color";
      description = "Sets $TERM. Def: screen";
      type = types.str;
    };
    newSession = mkOption { 
      description = "autospawn a session if none";
      default = true;
      type = types.bool;
    };
    secureSocket = mkOption { 
      description = "Socket under /run. More secure than /tmp, but doesn’t survive user logout";
      type = types.bool;
      default = false;
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

        

        set -g @dracula-show-left-icon "🌭"
        set -g @dracula-show-empty-plugins true
        set -g @dracula-refresh-rate 5

        set -g @dracula-plugins " ssh-session uptime time "

        set -g @dracula-show-ssh-only-when-connected true
        set -g @dracula-show-ssh-session-port true

        set -g @dracula-uptime-label "󱎫 "

        set -g @dracula-show-timezone false
        set -g @dracula-time-format "%R"

        source ~/.tmux
       '';
     };
    conf.postplugin = mkOption {
      description = "sets /etc/tmux.conf";
      type = types.lines;
      default = ''
        set-option -sa terminal-features ',xterm-256color:RGB' # Proper colors
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"
        
       '';
       /*
       #set-option -g allow-rename off  ##don't rename windows automatically
       */
    };
    plugins = mkOption {
      description = "";
      type = with types; listOf package;
      default = [
        pkgs.tmuxPlugins.dracula
       ];
     };
   };

  config = mkIf cfg.enable (mkMerge [
    ({programs.tmux = {
      enable        = true;
      keyMode       = "vi"; #"emacs"
      clock24       = true;
      newSession    = true;
      baseIndex     = 1;
      escapeTime    = 0; #waits after an escape key press, millisecs
      secureSocket  = cfg.secureSocket;
      shortcut      = cfg.shortcut;
      terminal      = cfg.term;
      plugins       = cfg.plugins;
      extraConfig   = cfg.conf.postplugin;
      extraConfigBeforePlugins = cfg.conf.preplugin;
    };})
    ({
      environment.systemPackages = with pkgs; [
        (writeShellApplication {
          name = "pux";
          runtimeInputs = [ tmux ];
          text = ''
              exec tmux -f ~/.tmux
          '';
        })
      ];
    })
   ]);
}
