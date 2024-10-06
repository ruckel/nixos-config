{ config, pkgs, lib, ... }:
let vars = import ./vars.nix;
in
{ imports =
    #./systemPackagesDefault.nix
  [ #./hardware-configuration.nix  # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    #./systemStateVersion.nix
    /etc/nixos/systemStateVersion.nix
    ./modules/ssh.nix
    ./modules/autorandr.nix
#   ./modules/customscripts.nix
    ./modules/adb.nix
    ./modules/dwm.nix
    ./modules/experimental.nix
    ./modules/ffsyncserver.nix
    ./modules/gnomeWM.nix
    ./modules/kbdLayout.nix
    ./modules/localization.nix
    ./modules/packages.nix
    ./modules/qemu.nix
    ./modules/sound.nix
    ./modules/syncthing.nix
    ./modules/systemd.nix
    ./modules/xprofile.nix
    ./modules/bashrc.nix
#./nixscripts/helloWorld.nix
  ];


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
  firewall = {
    enable = true;
    allowedTCPPorts = [ 5900 ];# [vnc]
    allowedUDPPorts = [ 5900 ];
    };
};


adb.enable          = true;
autorandr.enable   = true;
#scripts.enable      = true;
dwm.enable         = true;
ffsyncserver.enable = true;
gnomeWM.enable        = true;
kbdLayout.enable    = true;
localization.enable = true;
qemu.enable         = true;
soundconf.enable    = true;
ssh.enable          = true;
syncthing.enable    = true;
#systemdconf.enable  = true;

experimental = { #enable = true;
  enableSystembus-notify =  true;
  enableAvahi =             true;
  #enableRustdeskServer =   true;
  #enableVirtualScreen =    true;
  enableVncFirewall =       true;
};


environment.localBinInPath = true;
#environment.etc."bashrc".source = ./bashrc;
#environment.etc."xprofile".source = ./xprofile;

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
fonts.packages =
  with pkgs; [
    fira fira-code fira-code-nerdfont
    noto-fonts noto-fonts-cjk-sans
    ];

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
   enable = true;
   allowReboot = false; #true;
   channel = "https://channels.nixos.org/nixos-24.05";
};
}
