{ config, pkgs, lib, inputs, ... }:
let
vars = import "${inputs.vars}";
in
{ imports = [
  #./imports.nix
  /home/korv/nixos-cfg/imports.nix
  #"${inputs.imports}"
  ];

sops = {
  defaultSopsFile = /home/korv/nixos-cfg/secrets/secrets.yaml;
  defaultSopsFormat = "yaml";
  age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  age.keyFile = "/home/korv/.config/sops/age/keys.txt";
  age.generateKey = true;
  secrets = {
    "users/def".neededForUsers = true;
    "users/def" = {};
    pw.neededForUsers = true;
    "ports/p1".neededForUsers = true;
    "ports/p2".neededForUsers = true;
    "ports/p3".neededForUsers = true;
  };
};
environment.etc.test.source = config.sops.secrets."pw".path;

nix.settings.experimental-features = [ "nix-command" "flakes" ];

nix.extraOptions = ''
  plugin-files = ${pkgs.nix-plugins}/lib/nix/plugins
'';
nix.settings.plugin-files = "${pkgs.nix-plugins}/lib/nix/plugins";
nix.settings.extra-builtins-file = [ ../libs/extra-builtins.nix ];


system.stateVersion = "24.05";
services.displayManager.defaultSession = "none+dwm"; # "gnome"

services.devmon.enable = true; /* automatic device mounting daemon */
services.gvfs.enable = true; /* Mount, trash, and other functionalities */
services.tumbler.enable = true; /* Thumbnail support for images */
services.udisks2 = { enable = true; #settings = {};
  mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
  };
services.xserver = {
  enable = true;
  videoDrivers = [ "amdgpu" ];
};
services.mullvad-vpn.enable = true;
networking = {
  hostName = vars.host;
  networkmanager.enable = true;
  firewall.enable = true;
};


#adb.enable          = true;
#autorandr.enable    = true;
#scripts.enable      = true;
#customkbd.enable    = true;
dwm.enable          = true;
#ffsyncserver.enable = true;
#gnomeWM.enable      = true;
#localization.enable = true;
#qemu.enable         = true;
#pcon = {
#  enable = true;
#  gscon = false;
#  kde = true;
#};
#pythonconf.enable   = true;
#soundconf.enable    = true;
#ssh.enable          = true;
#syncthing.enable    = true;
#systemdconf.enable  = true;
#ollama.enable       = true;

#experimental = { #enable = true;
  #enableSystembus-notify =  true;
  #enableAvahi =             true;
  #enableRustdeskServer =   true;
  #enableVirtualScreen =    true;
  #enableVncFirewall =       true;
#};


environment.localBinInPath = true;

systemd.services = { # fix: github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  "getty@tty1".enable = false;
  "autovt@tty1".enable = false;
};
nixpkgs.config = {
  allowUnfree = true;
  permittedInsecurePackages = [
    "python3.11-youtube-dl-2021.12.17"
  ];
};


users.users.${vars.user} = { isNormalUser = true;
    description = "basic user";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ tilix bc ];
};
#fonts.packages = with pkgs; [
#    fira fira-code fira-code-nerdfont
#    noto-fonts noto-fonts-cjk-sans
#];

xdg = {
  autostart.enable = true;
  icons.enable = true;
  };
services.displayManager.autoLogin = {
  enable = true;
  user = vars.user;
};
services.xserver.displayManager.gdm = {
  enable = true;
  wayland = false;
};
boot.plymouth = { enable = true;
 #themePackages = [ ];
 #theme         = "";
 #logo          = "";
 #font          = "";
 #extraConfig   = "";
};
boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
#   grub = {
#     enable = true;
#     device = "/dev/sda"; /* vaio */
#     useOSProber = true;
#   };
};
nix.gc = { ## garbage collection
  automatic = true;
  dates = "06:00";
};
system.autoUpgrade = {
   #enable = true;
   allowReboot = false; #true;
   channel = "https://channels.nixos.org/nixos-unstable";
};
}
