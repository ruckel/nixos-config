{ config, pkgs, lib, inputs, ... }:
let vars = import "${inputs.vars}"; in
{ imports = [
  ../../modules/imports.nix
  ./hardware-configuration.nix
  ./packages.nix
  ];

services.displayManager.defaultSession = "none+dwm"; # "gnome"
adb = {
  enable            = true;
  user              = "korv";
  #ports             = vars.adbports;
};
autorandr.enable    = false;
scripts.enable      = true;
customkbd.enable    = true;
dwm.enable          = true;
dwm.user            = "korv";
ffsyncserver.enable = false;
gnomeWM.enable      = true;
#kde.enable	    = true;
localization.enable = true;
mysql.enable        = false;
nc.enable           = true;
qemu.enable         = true;
pcon = {
  enable = true;
  gscon = false;
  kde = true;
};
#pythonconf.enable   = true;
soundconf.enable    = true;
soundconf.user      = "korv";
ssh = {
  enable            = true;
  user              = "korv";
  ports             = [ 6842 6843 6844 ];
  keys              = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJsd82H9yUf2hgBiXECvfPVgUxy84vHz5MbsBDbShvv korv@nixos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPC8sV9tofPmdM1VmrsUK1AoymNkobPphDynC6nKd/E korv@nixos-dell"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIa8dGCkZtulhJ7Peg2XvdryhAowWpL0hVMAS+i0I1t5 root@debian-homelab"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEpTIZfMSLWJBzkvSZyCthrU40R0CB8GjRi0WUMxi62z korv@pixel"
  ];
  pwauth            = true;
  x11fw             = true;
  vncbg             = true;
};
syncthing.enable    = true;
syncthing.user      = "korv";
systemdconf.enable  = true;
#ollama.enable       = true;
xprofile.enable     = true;
xprofile.user       = "korv";

experimental = {
  enable                  = true;
  user                    = "korv";
  enableSystembus-notify  = false;
  enableAvahi             = true;
  enableRustdeskServer    = false;
  enableVirtualScreen     = false;
  enableVncFirewall       = true;
};
/* Constants */
nixpkgs.config = {
  allowUnfree = true;
  permittedInsecurePackages = [ "libsoup-2.74.3" "spotify" ];
  allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
 };
nix.settings.experimental-features = [ "nix-command" "flakes" ];
environment.localBinInPath = true;
system.stateVersion = "23.11";
services.devmon.enable = true; /* automatic device mounting daemon */
services.gvfs.enable = true; /* Mount, trash, and other functionalities */
services.tumbler.enable = true; /* Thumbnail support for images */
services.udisks2 = { enable = true; #settings = {};
  mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
  };
services.xserver.enable = true;
#services.mullvad-vpn.enable = true;
users.users."korv" = { isNormalUser = true;
    description = "korv";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ tilix bc ];
};
#environment.etc = {
#  "profile.d/vte.sh".source = "${pkgs.vte}/etc/profile.d/vte.sh";
#};
fonts.packages = with pkgs; [
    # nerdfonts /* All nerdfonts */
    fira fira-code nerd-fonts.fira-code
    noto-fonts noto-fonts-cjk-sans
];
xdg = {
  autostart.enable = true;
  icons.enable = true;
  portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  };
services.displayManager.autoLogin = {
  enable = true;
  user = "korv";
};
services.xserver.displayManager.gdm = {
  enable = true;
  wayland = false;
};
nix.gc = {        # nix store garbage collection
  automatic = true;
  dates = "06:00";
};
networking = {
  hostName = "dell";
  networkmanager.enable = true;
 #firewall.enable = true;
};
boot.loader = {
  systemd-boot.enable = true;
  efi.canTouchEfiVariables = true;
};
boot.plymouth.enable = true;
system.autoUpgrade = {
  enable = true;
  allowReboot = true;
  channel = "https://channels.nixos.org/nixos-24.05";
};
}
