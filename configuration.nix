{ config, pkgs, lib, ... }:
let vars = import ./vars.nix; # TODO: upgrade to github.com/Mic92/sops-nix
in
{ imports =
  [ #./hardware-configuration.nix  # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    #./systemPackagesDefault.nix
    #./systemStateVersion.nix
    /etc/nixos/systemStateVersion.nix
    ./modules/ssh.nix
    ./modules/autorandr.nix
    ./modules/customscripts.nix
    ./modules/adb.nix
    ./modules/localization.nix
    ./modules/dwm.nix
    ./modules/experimental.nix
    ./modules/gnome.nix
    ./modules/kbdLayout.nix
    ./modules/qemu.nix
    ./modules/sound.nix
    ./modules/ffsyncserver.nix
    ./modules/syncthing.nix
    ./modules/systemd.nix
  ];

# TODO services.displayManager.defaultSession = "none+dwm"; # "gnome"

services.devmon.enable = true; ## automatic device mounting daemon
services.gvfs.enable = true;
services.udisks2 = { enable = true; #settings = {};
  mountOnMedia = true; ## mount in /media/ instead of /run/media/$USER/
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
#autorandr.enable   = true;
scripts.enable      = true;
#dwm.enable         = true;
ffsyncserver.enable = true;
gnome.enable        = true;
#kbdLayout.enable    = true;
localization.enable = true;
qemu.enable         = true;
soundconf.enable    = true;
ssh.enable          = true;
syncthing.enable    = true;
systemdconf.enable  = true;

experimental = { enable = true;
  enableSystembus-notify =  true;
  enableAvahi =             true;
  #enableRustdeskServer =   true;
  #enableVirtualScreen =    true;
  enableVncFirewall =       true;
};

nixpkgs.config = {
  allowUnfree = true;
  permittedInsecurePackages = [
    "python3.11-youtube-dl-2021.12.17"
  ];
};
services.transmission.enable = true;


users.users.${vars.user} = { isNormalUser = true;
    description = "basic user";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ tilix vte bc ];
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