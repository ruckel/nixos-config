{ config, lib, pkgs, ... }:

{
  options.sxwm.enable = lib.mkEnableOption "SXWM window manager";

  config =/* lib.mkIf config.sxwm.enable*/ {        
        environment.systemPackages = with pkgs; [ 
          tilix
          mlterm
          kitty 
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
        programs.bash = {
          undistractMe = {
            enable = true;
            playSound = true;
            timeout = 10; #sec
          };
          completion.enable = true;
          vteIntegration = true;
           #shellAliases = { };
           #promptInit = ${builtins.readFile promptInitFile};
          shellInit = /* ${builtins.readFile shellInitFile}; */ ''echo "shellInit"'';
          loginShellInit = /* ${builtins.readFile loginInitFile}; */ ''echo "loginshellInit" '';
          interactiveShellInit = /* ${builtins.readFile interactiveShellInitFile};*/ ''echo "interactiveshellInit"'';
        };
        xdg.terminal-exec = {
          enable = true;
          settings = { default = [ "tilix.desktop" ]; };
        };
  };
}
