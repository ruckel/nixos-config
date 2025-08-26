{ config, lib, pkgs, ... }:

{
  #options.sxwm.enable = lib.mkEnableOption "SXWM window manager";

  config =/* lib.mkIf config.sxwm.enable*/ {        
        environment.systemPackages = with pkgs; [ 
          tilix
          mlterm
          kitty 
          wezterm
          fzf
          lazygit
          htop
          xorg.xev
          lsof 
          showmethekey 
          trashy 
          termimage 
          xprintidle 
          xdotool 
          place-cursor-at 
          mktemp 
          xclip
          tealdeer
          yazi
          jless
          jq
          gdu
          bat
        ] ;
        environment.etc."bashrc".text = ". /etc/bashaliases ";
        environment.etc."bashaliases".source = ./aliases.sh;
        environment.shellInit = ''
          alias paplay=pw-play
          alias pwplay=pw-play
        '';
        programs.bash = {
          undistractMe = {
            enable = true;
            playSound = false;
            timeout = 10; #sec
          };
          completion.enable = true;
          vteIntegration = true;
           #shellAliases = { };
           #promptInit = ${builtins.readFile promptInitFile};
          shellInit = /* ${builtins.readFile shellInitFile}; */ ''export SHELL_INIT=true'';
          loginShellInit = /* ${builtins.readFile loginInitFile}; */ ''export SHELL_INIT_LOGIN=true'';
          interactiveShellInit = /* ${builtins.readFile interactiveShellInitFile};*/ ''export SHELL_INIT_INTERACTIVE=true'';
        };
        xdg.sounds.enable = true;
        xdg.terminal-exec = {
          enable = true;
          settings = { default = [ "tilix.desktop" ]; };
        };
  };
}
