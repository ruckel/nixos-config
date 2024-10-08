/* Checkout original layout with: ```sh
less $(echo "$(nix-build --no-out-link '<nixpkgs>' -A xorg.xkeyboardconfig)/etc/X11/xkb/")symbols/se 00-keyboard.conf
``` */
{ lib, pkgs, config, ... } :
with lib;
let cfg = config.customkbd;
in {
  options.customkbd.enable = mkEnableOption "add custom keyboard layouts";

  config = lib.mkIf cfg.enable {
    services.xserver = {
      xkb.layout = "korvus";
      displayManager.sessionCommands = "setxkbmap korvus";
      xkb.extraLayouts.korvus = {
        description = "too lazy for a description";
        languages = [ "se" ];
        symbolsFile = ../xkbLayouts/symbols/korvus;
        #keycodesFile = ../xkbLayouts/symbols/korvus-key;
      };

    };
  environment.etc."xprofile2".text = ''setxkbmap korvus'';
  };
}