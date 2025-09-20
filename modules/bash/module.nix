{ config, lib, pkgs, ... }: with lib;
let
  cfg = config.shell;
  wrappedScripts = import ./included-scripts.nix { inherit pkgs; };
  unwrappedScripts = import ./included-scripts-not-wrapped.nix { inherit pkgs; };

  makeWrappedScript = { name, file, deps }: pkgs.writeShellScriptBin name ''
    export PATH=${pkgs.lib.makeBinPath deps}
    ${builtins.readFile file}
  '';
  makeUnwrappedScript = { name, file, aliases }: pkgs.writeScriptBin name ''
    ${builtins.readFile file}
  '';

  packageListWrapped = builtins.listToAttrs (
    map (def: {
      name = def.name;
      value = makeWrappedScript def;
    }) wrappedScripts
  );
  packageListUnwrapped = builtins.listToAttrs (
    map (def: {
      name = def.name;
      value = makeUnwrappedScript def;
    }) unwrappedScripts
  );
in
{
  options.shell = {scripts = mkEnableOption "";};

  config = (mkMerge [
    ( mkIf cfg.scripts {
      environment.systemPackages = builtins.attrValues packageListWrapped ++ builtins.attrValues packageListUnwrapped;
    })
    ({
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
#        termimage
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
      environment.shellAliases = {
        tilix = "env GTK_THEME=Adwaita:dark tilix";
        paplay = "pw-play";
        pwplay = "pw-play";

      };
      environment.etc."bashrc".text = ". /etc/bashaliases ";
      environment.etc."bashaliases".source = ./aliases.sh;
      environment.shellInit = ''
        alias keepassxc
      '';
      programs.screen.enable = true;
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
    })
  ]);
}
